import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../constants/default_categories.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Tags,
    Treasures,
    TreasureTags,
    Sources,
    TestRecords,
    Contents,
    ContentMetrics,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'tech_treasure.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedDefaultCategories();
      await _createIndexes();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );

  Future<void> _seedDefaultCategories() async {
    final now = DateTime.now();
    for (final item in kDefaultCategories) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: item.id,
          name: item.name,
          description: Value(item.description),
          icon: item.icon,
          isDefault: const Value(true),
          createdAt: now,
        ),
      );
    }
  }

  Future<void> _createIndexes() async {
    // Indexes to optimize sub-millisecond querying across collections
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treasures_category ON treasures(category_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treasures_status ON treasures(status);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treasures_verified_noapp ON treasures(is_verified, no_app_needed);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treasures_favorites ON treasures(is_favorite);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treasures_updated ON treasures(updated_at DESC);',
    );

    // SQLite FTS5 Full-Text Search virtual table and triggers
    try {
      await customStatement('''
        CREATE VIRTUAL TABLE IF NOT EXISTS treasures_fts USING fts5(
          id UNINDEXED,
          title,
          short_description,
          problem,
          solution,
          requirements,
          limitations
        );
      ''');

      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS treasures_ai AFTER INSERT ON treasures BEGIN
          INSERT INTO treasures_fts(id, title, short_description, problem, solution, requirements, limitations)
          VALUES (new.id, new.title, new.short_description, new.problem, new.solution, new.requirements, new.limitations);
        END;
      ''');

      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS treasures_ad AFTER DELETE ON treasures BEGIN
          DELETE FROM treasures_fts WHERE id = old.id;
        END;
      ''');

      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS treasures_au AFTER UPDATE ON treasures BEGIN
          DELETE FROM treasures_fts WHERE id = old.id;
          INSERT INTO treasures_fts(id, title, short_description, problem, solution, requirements, limitations)
          VALUES (new.id, new.title, new.short_description, new.problem, new.solution, new.requirements, new.limitations);
        END;
      ''');
    } catch (_) {
      // FTS5 might not be compiled into custom SQLite builds on rare environments
    }
  }
}
