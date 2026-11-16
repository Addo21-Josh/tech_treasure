import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_treasure/core/constants/app_enums.dart';
import 'package:tech_treasure/core/database/app_database.dart';
import 'package:tech_treasure/features/content/data/daos/contents_dao.dart';
import 'package:tech_treasure/features/content/data/repositories/content_repository_impl.dart';
import 'package:tech_treasure/features/content/domain/entities/content_entity.dart';
import 'package:tech_treasure/features/content/domain/entities/content_metrics_entity.dart';
import 'package:tech_treasure/features/treasures/data/daos/treasures_dao.dart';
import 'package:tech_treasure/features/treasures/data/repositories/treasure_repository_impl.dart';
import 'package:tech_treasure/features/treasures/domain/entities/treasure_entity.dart';

void main() {
  late AppDatabase db;
  late TreasuresDao treasuresDao;
  late TreasureRepositoryImpl treasureRepo;
  late ContentsDao contentsDao;
  late ContentRepositoryImpl contentRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    treasuresDao = TreasuresDao(db);
    treasureRepo = TreasureRepositoryImpl(treasuresDao);
    contentsDao = ContentsDao(db);
    contentRepo = ContentRepositoryImpl(contentsDao);
  });

  tearDown(() async {
    await db.close();
  });

  test('Creates content script and estimates reading duration accurately', () async {
    // 1. Create a treasure
    final treasure = TreasureEntity(
      id: 't-content-1',
      title: 'WhatsApp Silent Voice Notes',
      shortDescription: 'Play voice notes without holding phone to ear or disturbing others.',
      categoryId: 'cat_phone_tricks',
      steps: const ['Open chat', 'Hold phone to ear', 'Sensor routes audio to earpiece'],
      contentPotential: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await treasureRepo.createTreasure(treasure);

    // 2. Create content entity
    final content = ContentEntity(
      id: 'c-content-1',
      treasureId: treasure.id,
      contentType: ContentType.youtubeShort,
      hook: 'Stop playing voice notes on loudspeaker in public!',
      problem: 'Everyone around you hears your private messages and personal drama.',
      demonstration: 'Just raise your phone to your ear like a normal call. The proximity sensor automatically switches audio from speaker to earpiece!',
      script: 'Stop playing voice notes on loudspeaker in public! Everyone around you hears your private messages. Just raise your phone to your ear like a phone call. The proximity sensor automatically switches audio to earpiece. Follow for more hidden tech tricks!',
      cta: 'Follow @TechTreasure for more daily tech discoveries!',
      status: 'scripted',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final saveResult = await contentRepo.saveContent(content);
    expect(saveResult.isSuccess, isTrue);

    // 3. Fetch content
    final fetchResult = await contentRepo.getContentForTreasure(treasure.id);
    expect(fetchResult.isSuccess, isTrue);
    final fetched = fetchResult.valueOrNull;
    expect(fetched, isNotNull);
    expect(fetched!.hook, contains('Stop playing voice notes'));
    expect(fetched.contentType, equals(ContentType.youtubeShort));

    // Word count check
    expect(fetched.wordCount, greaterThan(30));
    expect(fetched.estimatedSeconds, greaterThan(10));
    expect(fetched.formattedEstimatedDuration, isNotEmpty);
  });

  test('Records performance metrics snapshots and calculates rates', () async {
    final treasure = TreasureEntity(
      id: 't-content-2',
      title: 'Fast Clipboard History in Windows',
      shortDescription: 'Press Win+V to access clipboard history',
      categoryId: 'cat_windows',
      steps: const ['Press Windows key + V', 'Enable history', 'Paste earlier clips'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await treasureRepo.createTreasure(treasure);

    final content = ContentEntity.fresh(
      id: 'c-content-2',
      treasureId: treasure.id,
      contentType: ContentType.tiktok,
    ).copyWith(
      publishedAt: DateTime.now(),
      status: 'published',
      platformUrl: 'https://tiktok.com/@tech/video/12345',
    );
    await contentRepo.saveContent(content);

    // Log day 1 metrics
    final day1 = ContentMetricsEntity(
      id: 'm-day-1',
      contentId: content.id,
      views: 10000,
      likes: 1200,
      comments: 80,
      shares: 350,
      saves: 850,
      followersGained: 140,
      performanceNotes: 'High initial retention curve on TikTok FYP',
      recordedAt: DateTime.now(),
    );

    final recordRes = await contentRepo.recordMetrics(day1);
    expect(recordRes.isSuccess, isTrue);

    // Fetch metrics
    final metricsRes = await contentRepo.getMetricsForContent(content.id);
    expect(metricsRes.isSuccess, isTrue);
    final list = metricsRes.valueOrNull!;
    expect(list.length, equals(1));

    final recorded = list.first;
    expect(recorded.views, equals(10000));
    expect(recorded.totalEngagements, equals(1200 + 80 + 350 + 850)); // 2480
    // Engagement rate = 2480 / 10000 * 100 = 24.8%
    expect(recorded.engagementRate, closeTo(24.8, 0.01));
    // Save rate = 850 / 10000 * 100 = 8.5%
    expect(recorded.saveRate, closeTo(8.5, 0.01));
  });

  test('Deleting a treasure cascades and removes content deliverables', () async {
    final treasure = TreasureEntity(
      id: 't-content-3',
      title: 'Temporary Cascade Test',
      shortDescription: 'Testing cascade on delete',
      categoryId: 'cat_phone_tricks',
      steps: const ['Step 1'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await treasureRepo.createTreasure(treasure);

    final content = ContentEntity.fresh(
      id: 'c-content-3',
      treasureId: treasure.id,
    );
    await contentRepo.saveContent(content);

    final metric = ContentMetricsEntity(
      id: 'm-content-3',
      contentId: content.id,
      views: 500,
      recordedAt: DateTime.now(),
    );
    await contentRepo.recordMetrics(metric);

    // Verify present
    expect((await contentRepo.getContentForTreasure(treasure.id)).valueOrNull, isNotNull);
    expect((await contentRepo.getMetricsForContent(content.id)).valueOrNull!.length, equals(1));

    // Delete treasure
    await treasureRepo.deleteTreasure(treasure.id);

    // Verify cascade
    expect((await contentRepo.getContentForTreasure(treasure.id)).valueOrNull, isNull);
    expect((await contentRepo.getMetricsForContent(content.id)).valueOrNull!.length, equals(0));
  });
}

