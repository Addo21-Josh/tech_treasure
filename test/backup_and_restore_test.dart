import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_treasure/core/constants/app_enums.dart';
import 'package:tech_treasure/core/database/app_database.dart';
import 'package:tech_treasure/features/content/data/daos/contents_dao.dart';
import 'package:tech_treasure/features/content/data/repositories/content_repository_impl.dart';
import 'package:tech_treasure/features/content/domain/entities/content_entity.dart';
import 'package:tech_treasure/features/content/domain/entities/content_metrics_entity.dart';
import 'package:tech_treasure/features/research/data/daos/sources_dao.dart';
import 'package:tech_treasure/features/research/data/repositories/source_repository_impl.dart';
import 'package:tech_treasure/features/research/domain/entities/source_entity.dart';
import 'package:tech_treasure/features/settings/data/services/backup_service.dart';
import 'package:tech_treasure/features/testing/data/daos/tests_dao.dart';
import 'package:tech_treasure/features/testing/data/repositories/test_repository_impl.dart';
import 'package:tech_treasure/features/testing/domain/entities/test_record_entity.dart';
import 'package:tech_treasure/features/treasures/data/daos/treasures_dao.dart';
import 'package:tech_treasure/features/treasures/data/repositories/treasure_repository_impl.dart';
import 'package:tech_treasure/features/treasures/domain/entities/treasure_entity.dart';

void main() {
  late AppDatabase db;
  late TreasuresDao treasuresDao;
  late TreasureRepositoryImpl treasureRepo;
  late SourcesDao sourcesDao;
  late SourceRepositoryImpl sourceRepo;
  late TestsDao testsDao;
  late TestRepositoryImpl testRepo;
  late ContentsDao contentsDao;
  late ContentRepositoryImpl contentRepo;
  late BackupService backupService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    treasuresDao = TreasuresDao(db);
    treasureRepo = TreasureRepositoryImpl(treasuresDao);
    sourcesDao = SourcesDao(db);
    sourceRepo = SourceRepositoryImpl(sourcesDao);
    testsDao = TestsDao(db);
    testRepo = TestRepositoryImpl(testsDao);
    contentsDao = ContentsDao(db);
    contentRepo = ContentRepositoryImpl(contentsDao);
    backupService = BackupService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('JSON backup generation produces v1.0 schema with verifiable SHA-256 checksum', () async {
    // 1. Populate records
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 't-backup-1',
      title: 'ADB Fast Wireless Debugging',
      shortDescription: 'Connect Android Studio to device without any cables.',
      categoryId: 'cat_phone_tricks',
      steps: const ['Enable Developer Options', 'Tap Wireless Debugging', 'Pair with code'],
      contentPotential: 5,
      createdAt: now,
      updatedAt: now,
    );
    final createTreasureRes = await treasureRepo.createTreasure(treasure);
    expect(createTreasureRes.isSuccess, isTrue);

    final source = SourceEntity(
      id: 's-backup-1',
      treasureId: treasure.id,
      title: 'Android Developers Portal',
      url: 'https://developer.android.com/tools/adb',
      sourceType: SourceType.officialDoc,
      createdAt: now,
    );
    final addSourceRes = await sourceRepo.addSource(source);
    expect(addSourceRes.isSuccess, isTrue);

    final testRecord = TestRecordEntity(
      id: 'tr-backup-1',
      treasureId: treasure.id,
      device: 'Google Pixel 8',
      osVersion: 'Android 14',
      environment: 'Office Wi-Fi 6',
      result: TestResult.works,
      notes: 'Latency under 5ms, flawless connection.',
      testedAt: now,
    );
    final addTestRes = await testRepo.addTestRecord(testRecord);
    expect(addTestRes.isSuccess, isTrue);

    // 2. Generate backup
    final backupResult = await backupService.generateJsonBackup();
    expect(backupResult.isSuccess, isTrue);

    final jsonString = backupResult.valueOrNull!;
    final Map<String, dynamic> parsed = jsonDecode(jsonString);

    expect(parsed['version'], '1.0.0');
    expect(parsed['schemaVersion'], 1);
    expect(parsed['metadata'], isNotNull);
    expect(parsed['metadata']['checksum'], isNotNull);
    expect((parsed['metadata']['checksum'] as String).startsWith('sha256-'), isTrue);

    final data = parsed['data'] as Map<String, dynamic>;
    final treasures = data['treasures'] as List;
    expect(treasures.length, 1);
    expect(treasures.first['title'], 'ADB Fast Wireless Debugging');

    final sources = data['sources'] as List;
    expect(sources.length, 1);
    expect(sources.first['url'], 'https://developer.android.com/tools/adb');

    final tests = data['testRecords'] as List;
    expect(tests.length, 1);
    expect(tests.first['device'], 'Google Pixel 8');
  });

  test('validateBackup verifies untampered backup and catches corrupted checksums', () async {
    final now = DateTime.now();
    final createRes = await treasureRepo.createTreasure(
      TreasureEntity(
        id: 't-val-1',
        title: 'Vim Motions in Obsidian',
        shortDescription: 'Navigate markdown without leaving home row.',
        categoryId: 'cat_productivity',
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(createRes.isSuccess, isTrue);

    final backupResult = await backupService.generateJsonBackup();
    final jsonString = backupResult.valueOrNull!;

    // 1. Valid backup verification
    final validation = await backupService.validateBackup(jsonString);
    expect(validation.isSuccess, isTrue);
    final summary = validation.valueOrNull!;
    expect(summary.totalTreasures, 1);

    // 2. Tampered backup (modify title in payload without updating sha256 checksum)
    final tamperedString = jsonString.replaceAll('Vim Motions in Obsidian', 'Malicious Hack in Obsidian');
    final tamperedValidation = await backupService.validateBackup(tamperedString);
    expect(tamperedValidation.isFailure, isTrue);
    expect(tamperedValidation.failureOrNull?.message, contains('SHA-256 integrity verification failed'));

    // 3. Invalid JSON structure
    final invalidValidation = await backupService.validateBackup('{"invalid": true}');
    expect(invalidValidation.isFailure, isTrue);
    expect(invalidValidation.failureOrNull?.message, contains('Incompatible backup version'));
  });

  test('Atomic database restoration cleanly overwrites and preserves relational integrity and FTS5 search', () async {
    final now = DateTime.now();

    // 1. Create initial treasure and content
    final treasureOriginal = TreasureEntity(
      id: 't-restore-1',
      title: 'Universal Clipboard Across Ecosystems',
      shortDescription: 'Sync clipboard between Mac and Android seamlessly.',
      categoryId: 'cat_phone_pc',
      steps: const ['Install tool', 'Enable peer discovery'],
      createdAt: now,
      updatedAt: now,
    );
    final createRes = await treasureRepo.createTreasure(treasureOriginal);
    expect(createRes.isSuccess, isTrue);

    final contentOriginal = ContentEntity(
      id: 'c-restore-1',
      treasureId: treasureOriginal.id,
      contentType: ContentType.youtubeShort,
      hook: 'Copy on Android, paste on Mac instantly!',
      problem: 'Transferring text between platforms is frustrating.',
      demonstration: 'Select text and paste anywhere.',
      script: 'Full script for seamless clipboard sharing.',
      cta: 'Subscribe for more cross-device tricks!',
      status: 'published',
      createdAt: now,
      updatedAt: now,
    );
    final saveContentRes = await contentRepo.saveContent(contentOriginal);
    expect(saveContentRes.isSuccess, isTrue);

    final metricOriginal = ContentMetricsEntity(
      id: 'm-restore-1',
      contentId: contentOriginal.id,
      views: 125000,
      likes: 8500,
      comments: 340,
      shares: 1200,
      saves: 3400,
      followersGained: 450,
      performanceNotes: 'Excellent viral reach.',
      recordedAt: now,
    );
    final recordMetricsRes = await contentRepo.recordMetrics(metricOriginal);
    expect(recordMetricsRes.isSuccess, isTrue);

    // Export backup
    final backupResult = await backupService.generateJsonBackup();
    final jsonString = backupResult.valueOrNull!;

    // 2. Mutate database (delete treasure, add a temporary junk treasure)
    await treasureRepo.deleteTreasure(treasureOriginal.id);
    await treasureRepo.createTreasure(
      TreasureEntity(
        id: 't-junk',
        title: 'Temporary Junk Item',
        shortDescription: 'To be wiped by restore',
        categoryId: 'cat_other',
        createdAt: now,
        updatedAt: now,
      ),
    );

    var currentTreasures = (await treasureRepo.getTreasures()).valueOrNull!;
    expect(currentTreasures.length, 1);
    expect(currentTreasures.first.id, 't-junk');

    // 3. Restore backup
    final restoreResult = await backupService.restoreBackup(jsonString);
    expect(restoreResult.isSuccess, isTrue);

    // 4. Verify restored state
    final restoredTreasures = (await treasureRepo.getTreasures()).valueOrNull!;
    expect(restoredTreasures.length, 1);
    expect(restoredTreasures.first.id, 't-restore-1');
    expect(restoredTreasures.first.title, 'Universal Clipboard Across Ecosystems');

    // Verify content and metrics restored
    final restoredContentResult = await contentRepo.getContentForTreasure('t-restore-1');
    expect(restoredContentResult.isSuccess, isTrue);
    final restoredContent = restoredContentResult.valueOrNull;
    expect(restoredContent, isNotNull);
    expect(restoredContent!.hook, 'Copy on Android, paste on Mac instantly!');

    final restoredMetricsResult = await contentRepo.getMetricsForContent(restoredContent.id);
    expect(restoredMetricsResult.isSuccess, isTrue);
    final restoredMetrics = restoredMetricsResult.valueOrNull!;
    expect(restoredMetrics.length, 1);
    expect(restoredMetrics.first.views, 125000);

    // Verify FTS5 search works on restored data
    final searchResults = (await treasureRepo.searchTreasures('Ecosystems')).valueOrNull!;
    expect(searchResults.length, 1);
    expect(searchResults.first.title, 'Universal Clipboard Across Ecosystems');
  });

  test('generateCsvExport produces RFC 4180 compliant CSV format with properly escaped fields', () async {
    final now = DateTime.now();
    final createRes = await treasureRepo.createTreasure(
      TreasureEntity(
        id: 't-csv-1',
        title: 'Multi-Monitor Virtual KVM, "Barrier"',
        shortDescription: 'Share mouse & keyboard across Windows, Mac, and Linux.',
        problem: 'Too many cables, dongles, and physical switches.',
        solution: 'Barrier uses local network packets to glide cursor between screens.',
        categoryId: 'cat_productivity',
        steps: const ['Install Barrier on primary PC', 'Configure client screen positions', 'Start server'],
        isVerified: true,
        contentPotential: 5,
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(createRes.isSuccess, isTrue);

    final csvResult = await backupService.generateCsvExport();
    expect(csvResult.isSuccess, isTrue);

    final csv = csvResult.valueOrNull!;
    final lines = csv.split('\n');

    // 1. Header verification
    expect(lines.first, startsWith('id,title,category,status,is_verified,is_favorite,no_app_needed,content_potential,device,platform,os_version,sources_count,tests_count,has_content,published_date,total_views,total_saves,created_at,updated_at'));

    // 2. Escaping verification (title with quotes and commas must be enclosed in quotes with double quotes)
    final recordLine = lines[1];
    expect(recordLine, contains('"Multi-Monitor Virtual KVM, ""Barrier"""'));
    expect(recordLine, contains('Productivity'));
    expect(recordLine, contains('Yes')); // is_verified
  });
}
