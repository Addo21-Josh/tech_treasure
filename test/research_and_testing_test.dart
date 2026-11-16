import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_treasure/core/constants/app_enums.dart';
import 'package:tech_treasure/core/database/app_database.dart';
import 'package:tech_treasure/features/research/data/daos/sources_dao.dart';
import 'package:tech_treasure/features/research/data/repositories/source_repository_impl.dart';
import 'package:tech_treasure/features/research/domain/entities/source_entity.dart';
import 'package:tech_treasure/features/testing/data/daos/tests_dao.dart';
import 'package:tech_treasure/features/testing/data/repositories/test_repository_impl.dart';
import 'package:tech_treasure/features/testing/domain/entities/test_record_entity.dart';
import 'package:tech_treasure/features/treasures/data/daos/treasures_dao.dart';
import 'package:tech_treasure/features/treasures/data/repositories/treasure_repository_impl.dart';
import 'package:tech_treasure/features/treasures/domain/entities/treasure_entity.dart';

void main() {
  late AppDatabase db;
  late TreasuresDao treasuresDao;
  late SourcesDao sourcesDao;
  late TestsDao testsDao;
  late TreasureRepositoryImpl treasureRepo;
  late SourceRepositoryImpl sourceRepo;
  late TestRepositoryImpl testRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    treasuresDao = TreasuresDao(db);
    sourcesDao = SourcesDao(db);
    testsDao = TestsDao(db);
    treasureRepo = TreasureRepositoryImpl(treasuresDao);
    sourceRepo = SourceRepositoryImpl(sourcesDao);
    testRepo = TestRepositoryImpl(testsDao);
  });

  tearDown(() async {
    await db.close();
  });

  test('Adds and retrieves research citations for a treasure', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'res_tr_001',
      title: 'Turn Phone Into PC Mouse',
      shortDescription: 'Wireless mouse trick',
      categoryId: 'cat_phone_pc',
      createdAt: now,
      updatedAt: now,
    );
    await treasureRepo.createTreasure(treasure);

    final source = SourceEntity(
      id: 'src_001',
      treasureId: 'res_tr_001',
      title: 'KDE Connect Docs',
      url: 'https://kdeconnect.kde.org',
      sourceType: SourceType.officialDoc,
      notes: 'Requires same local subnet',
      createdAt: now,
    );

    final addResult = await sourceRepo.addSource(source);
    expect(addResult.isSuccess, isTrue);

    final listResult = await sourceRepo.getSourcesForTreasure('res_tr_001');
    expect(listResult.isSuccess, isTrue);
    final sources = listResult.valueOrNull!;
    expect(sources.length, 1);
    expect(sources.first.title, 'KDE Connect Docs');
    expect(sources.first.sourceType, SourceType.officialDoc);
  });

  test('Logs multiple empirical device tests and records results', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'test_tr_002',
      title: 'Clipboard Sync Between Devices',
      shortDescription: 'Cross-device copy paste',
      categoryId: 'cat_phone_pc',
      createdAt: now,
      updatedAt: now,
    );
    await treasureRepo.createTreasure(treasure);

    // Test 1: Samsung Galaxy (Works)
    final test1 = TestRecordEntity(
      id: 'test_rec_001',
      treasureId: 'test_tr_002',
      device: 'Samsung Galaxy S24',
      osVersion: 'Android 16',
      environment: 'Windows 11 Wi-Fi 6',
      result: TestResult.works,
      notes: 'Instant sync with Link to Windows',
      testedAt: now,
    );
    final res1 = await testRepo.addTestRecord(test1);
    expect(res1.isSuccess, isTrue);

    // Test 2: iPhone (Partially Works)
    final test2 = TestRecordEntity(
      id: 'test_rec_002',
      treasureId: 'test_tr_002',
      device: 'iPhone 15 Pro',
      osVersion: 'iOS 18',
      environment: 'Windows 11',
      result: TestResult.partiallyWorks,
      notes: 'Requires manual pasteboard sync app',
      testedAt: now,
    );
    final res2 = await testRepo.addTestRecord(test2);
    expect(res2.isSuccess, isTrue);

    final allTestsResult = await testRepo.getTestsForTreasure('test_tr_002');
    expect(allTestsResult.isSuccess, isTrue);
    final tests = allTestsResult.valueOrNull!;
    expect(tests.length, 2);
  });

  test('Deleting a treasure cascades and removes sources and tests', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'cascade_tr',
      title: 'Temporary Hack',
      shortDescription: 'Will be deleted',
      categoryId: 'cat_other',
      createdAt: now,
      updatedAt: now,
    );
    await treasureRepo.createTreasure(treasure);

    await sourceRepo.addSource(
      SourceEntity(
        id: 'src_del',
        treasureId: 'cascade_tr',
        title: 'Blog Post',
        createdAt: now,
      ),
    );

    await testRepo.addTestRecord(
      TestRecordEntity(
        id: 'test_del',
        treasureId: 'cascade_tr',
        device: 'Pixel 8',
        osVersion: 'Android 15',
        testedAt: now,
      ),
    );

    // Verify records exist
    expect((await sourceRepo.getSourcesForTreasure('cascade_tr')).valueOrNull!.length, 1);
    expect((await testRepo.getTestsForTreasure('cascade_tr')).valueOrNull!.length, 1);

    // Delete parent treasure
    await treasureRepo.deleteTreasure('cascade_tr');

    // Verify cascading deletion cleaned up children
    expect((await sourceRepo.getSourcesForTreasure('cascade_tr')).valueOrNull!, isEmpty);
    expect((await testRepo.getTestsForTreasure('cascade_tr')).valueOrNull!, isEmpty);
  });
}

