# 🧪 Testing Strategy & Quality Assurance

This document details the automated testing pyramid, test harnesses, in-memory database testing, widget tests, and continuous integration standards for **Tech Treasure Database**.

---

## 1. Testing Pyramid Overview

```text
       ┌────────────────────────┐
       │   Integration Tests    │  ~10% (End-to-End Creator Journey)
       ├────────────────────────┤
       │      Widget Tests      │  ~30% (Cards, Bottom Sheets, Search)
       ├────────────────────────┤
       │  Unit & Database Tests │  ~60% (Domain Models, DAOs, Notifiers)
       └────────────────────────┘
```

| Test Type | Scope | Execution Target | Tooling |
|---|---|---|---|
| **Unit Tests** | Domain entities, Result monad, Notifiers, Backup validator | < 5 seconds | `flutter_test`, `mocktail` |
| **DAO / DB Tests** | Drift tables, FTS queries, cascading deletes, transactions | < 10 seconds | `drift/native.dart` (In-memory SQLite) |
| **Widget Tests** | Atomic cards, pills, Quick Capture sheet, validation forms | < 15 seconds | `flutter_test`, `golden_toolkit` |
| **Integration** | Complete offline loop: Capture ➔ Verify ➔ Script ➔ Backup | < 60 seconds | `integration_test` package |

---

## 2. In-Memory Database Test Harness (Drift)

Because Tech Treasure relies heavily on structured SQLite relationships, unit tests do **not** mock database calls. Instead, tests run against real, lightning-fast in-memory SQLite instances.

```dart
// test/helpers/test_database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:tech_treasure/core/database/app_database.dart';

AppDatabase createTestDatabase() {
  return AppDatabase(
    NativeDatabase.memory(
      setup: (rawDb) {
        // Enforce foreign key constraints in SQLite test runner
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    ),
  );
}
```

### 2.1 Example DAO Unit Test
```dart
void main() {
  late AppDatabase db;

  setUp(() {
    db = createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  test('Inserting a treasure and cascading delete removes related sources', () async {
    final categoryId = 'cat_test';
    await db.into(db.categories).insert(
      CategoriesCompanion.insert(
        id: categoryId,
        name: 'Test Category',
        icon: 'devices',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    final treasureId = 'treasure_test_001';
    await db.into(db.treasures).insert(
      TreasuresCompanion.insert(
        id: treasureId,
        title: 'USB Tethering Trick',
        shortDescription: 'Share internet without hotspot limits',
        categoryId: categoryId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    await db.into(db.sources).insert(
      SourcesCompanion.insert(
        id: 'src_001',
        treasureId: treasureId,
        title: 'Android Docs',
        sourceType: 'officialDoc',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    // Verify source exists
    final sourcesBefore = await (db.select(db.sources)..where((s) => s.treasureId.equals(treasureId))).get();
    expect(sourcesBefore.length, 1);

    // Delete parent treasure
    await (db.delete(db.treasures)..where((t) => t.id.equals(treasureId))).go();

    // Verify cascading delete removed source
    final sourcesAfter = await (db.select(db.sources)..where((s) => s.treasureId.equals(treasureId))).get();
    expect(sourcesAfter, isEmpty);
  });
}
```

---

## 3. Riverpod Notifier Unit Testing

Testing Riverpod `AsyncNotifier` state without rendering Flutter widgets:

```dart
test('TreasureDetailController toggles favorite status correctly', () async {
  final container = ProviderContainer(
    overrides: [
      treasureRepositoryProvider.overrideWithValue(mockTreasureRepository),
    ],
  );
  addTearDown(container.dispose);

  when(() => mockTreasureRepository.toggleFavorite('id_123'))
      .thenAnswer((_) async => const Success(true));

  final controller = container.read(treasureDetailControllerProvider('id_123').notifier);
  await controller.toggleFavorite();

  expect(container.read(treasureDetailControllerProvider('id_123')).value?.treasure.isFavorite, isTrue);
});
```

---

## 4. Backup & Restore Integrity Tests

Critical tests verifying zero data corruption during export and import:

1. **Checksum Verification**: Corrupted JSON bytes must be rejected with `BackupCorruptFailure`.
2. **Atomic Rollback**: If an invalid foreign key is introduced halfway through a restore payload, the database transaction rolls back cleanly without leaving orphan rows.
3. **Roundtrip Fidelity**: `exportToBackup()` followed by `restoreFromBackup()` yields an identical record set.

---

## 5. End-to-End Integration Scenario

The integration test simulates the exact workflow defined in PRD Section 44:

```dart
// integration_test/creator_workflow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full Offline Creator Workflow Test', (tester) async {
    // 1. Launch App
    await tester.pumpWidget(const ProviderScope(child: TechTreasureApp()));
    await tester.pumpAndSettle();

    // 2. Open Quick Capture FAB
    await tester.tap(find.byKey(const Key('fab_quick_capture')));
    await tester.pumpAndSettle();

    // 3. Enter Title and Category
    await tester.enterText(find.byKey(const Key('input_treasure_title')), 'Android Phone as PC Mouse');
    await tester.tap(find.byKey(const Key('btn_quick_save')));
    await tester.pumpAndSettle();

    // 4. Navigate to Treasures and open details
    await tester.tap(find.text('Android Phone as PC Mouse'));
    await tester.pumpAndSettle();

    // 5. Add Test Record (Works)
    await tester.tap(find.byKey(const Key('btn_add_test_record')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('input_test_device')), 'Galaxy S24');
    await tester.tap(find.text('Works'));
    await tester.tap(find.byKey(const Key('btn_save_test')));
    await tester.pumpAndSettle();

    // 6. Complete Verification Checklist
    await tester.tap(find.byKey(const Key('btn_mark_verified')));
    await tester.pumpAndSettle();

    // 7. Verify status badge updated to "Verified"
    expect(find.text('Verified'), findsOneWidget);
  });
}
```

---

## 6. Continuous Integration (CI) Checks

Every Pull Request must pass the following checks:
```bash
# 1. Static code analysis
flutter analyze --fatal-infos --fatal-warnings

# 2. Check formatting
dart format --output=none --set-exit-if-changed .

# 3. Run all unit and widget tests with coverage
flutter test --coverage

# 4. Enforce minimum coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib
```

