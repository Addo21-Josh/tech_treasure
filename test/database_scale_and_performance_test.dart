// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_treasure/core/constants/app_enums.dart';
import 'package:tech_treasure/core/database/app_database.dart';
import 'package:tech_treasure/features/settings/data/services/backup_service.dart';
import 'package:tech_treasure/features/treasures/data/daos/treasures_dao.dart';
import 'package:tech_treasure/features/treasures/data/repositories/treasure_repository_impl.dart';

void main() {
  late AppDatabase db;
  late TreasuresDao treasuresDao;
  late TreasureRepositoryImpl treasureRepo;
  late BackupService backupService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    treasuresDao = TreasuresDao(db);
    treasureRepo = TreasureRepositoryImpl(treasuresDao);
    backupService = BackupService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Database scales efficiently with 1,000 records and maintains low-latency FTS5 queries', () async {
    final now = DateTime.now();

    // 1. Bulk insert 1,000 mock records using a single batch transaction
    final stopwatch = Stopwatch()..start();

    await db.batch((batch) {
      final companions = List.generate(1000, (i) {
        final statusIndex = i % TreasureStatus.values.length;
        final status = TreasureStatus.values[statusIndex].name;
        final isVerified = i % 2 == 0;
        final noApp = i % 3 == 0;
        final potential = (i % 5) + 1;

        return TreasuresCompanion.insert(
          id: 'scale_tr_$i',
          title: 'Optimized Discovery Trick #$i: Super Speed Wi-Fi $i',
          shortDescription: 'Comprehensive guide to optimizing hardware throughput for node #$i.',
          problem: Value('Network congestion and packet drop on device cluster $i.'),
          solution: Value('Configure custom DNS resolvers and disable power throttling.'),
          whyUseful: Value('Increases transfer speeds by up to 40%.'),
          categoryId: 'cat_internet',
          status: Value(status),
          device: Value('Pixel 8 / Windows 11 PC #$i'),
          platform: Value('Android / Windows'),
          osVersion: Value('Android 14 / Win 11 23H2'),
          requirements: Value('Local Wi-Fi 6 router'),
          stepsJson: Value(jsonEncode(['Step 1 for #$i', 'Step 2 for #$i', 'Step 3 for #$i'])),
          isVerified: Value(isVerified),
          noAppNeeded: Value(noApp),
          contentPotential: Value(potential),
          createdAt: now,
          updatedAt: now,
        );
      });

      batch.insertAll(db.treasures, companions);
    });

    stopwatch.stop();
    print('⚡ Ingested 1,000 records in ${stopwatch.elapsedMilliseconds}ms');
    expect(stopwatch.elapsedMilliseconds, lessThan(5000));

    // 2. Query status counts across 1,000 records
    final countsWatch = Stopwatch()..start();
    final counts = await treasuresDao.getStatusCounts();
    countsWatch.stop();

    print('⚡ Aggregated status counts in ${countsWatch.elapsedMilliseconds}ms');
    final totalCounted = counts.values.fold<int>(0, (a, b) => a + b);
    expect(totalCounted, 1000);
    expect(countsWatch.elapsedMilliseconds, lessThan(500));

    // 3. Perform SQLite FTS5 Full-Text Search across 1,000 records
    final searchWatch = Stopwatch()..start();
    final searchResults = (await treasureRepo.searchTreasures('throughput')).valueOrNull!;
    searchWatch.stop();

    print('⚡ FTS5 search across 1,000 records executed in ${searchWatch.elapsedMilliseconds}ms');
    expect(searchResults.length, 1000);
    expect(searchWatch.elapsedMilliseconds, lessThan(2000)); // Resilient under parallel test suite load

    // Targeted FTS5 search
    final targetedWatch = Stopwatch()..start();
    final targetResult = (await treasureRepo.searchTreasures('Trick #742')).valueOrNull!;
    targetedWatch.stop();

    print('⚡ Targeted FTS5 query executed in ${targetedWatch.elapsedMilliseconds}ms');
    expect(targetResult.length, 1);
    expect(targetResult.first.title, contains('#742'));
    expect(targetedWatch.elapsedMilliseconds, lessThan(500));

    // 4. Verify JSON backup generation with SHA-256 for 1,000 records
    final backupWatch = Stopwatch()..start();
    final backupResult = await backupService.generateJsonBackup();
    backupWatch.stop();

    print('⚡ Generated SHA-256 validated JSON backup for 1,000 records in ${backupWatch.elapsedMilliseconds}ms');
    expect(backupResult.isSuccess, isTrue);
    expect(backupWatch.elapsedMilliseconds, lessThan(1500));

    // 5. Verify CSV export for 1,000 records
    final csvWatch = Stopwatch()..start();
    final csvResult = await backupService.generateCsvExport();
    csvWatch.stop();

    print('⚡ Generated CSV export for 1,000 records in ${csvWatch.elapsedMilliseconds}ms');
    expect(csvResult.isSuccess, isTrue);
    final csvLines = csvResult.valueOrNull!.trim().split('\n');
    expect(csvLines.length, 1001); // 1 header + 1,000 data rows
    expect(csvWatch.elapsedMilliseconds, lessThan(1500));
  });
}
