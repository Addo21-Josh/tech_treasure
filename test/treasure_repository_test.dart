import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_treasure/core/constants/app_enums.dart';
import 'package:tech_treasure/core/database/app_database.dart';
import 'package:tech_treasure/features/treasures/data/daos/treasures_dao.dart';
import 'package:tech_treasure/features/treasures/data/repositories/treasure_repository_impl.dart';
import 'package:tech_treasure/features/treasures/domain/entities/treasure_entity.dart';
import 'package:tech_treasure/features/treasures/domain/entities/treasure_filter.dart';

void main() {
  late AppDatabase db;
  late TreasuresDao dao;
  late TreasureRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    dao = TreasuresDao(db);
    repository = TreasureRepositoryImpl(dao);
  });

  tearDown(() async {
    await db.close();
  });

  test('Creates a treasure and retrieves it by ID', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'test_123',
      title: 'Turn Phone Into PC Mouse',
      shortDescription: 'Emergency wireless mouse',
      categoryId: 'cat_phone_pc',
      status: TreasureStatus.idea,
      steps: const ['Open settings', 'Connect Wi-Fi'],
      contentPotential: 5,
      noAppNeeded: true,
      createdAt: now,
      updatedAt: now,
    );

    final createResult = await repository.createTreasure(treasure);
    if (createResult.isFailure) {
      // ignore: avoid_print
      print('DEBUG FAILURE: ${createResult.failureOrNull?.message} | Cause: ${createResult.failureOrNull?.cause}');
    }
    expect(createResult.isSuccess, isTrue, reason: createResult.failureOrNull?.message);

    final fetchResult = await repository.getTreasureById('test_123');
    expect(fetchResult.isSuccess, isTrue);
    final fetched = fetchResult.valueOrNull!;
    expect(fetched.title, 'Turn Phone Into PC Mouse');
    expect(fetched.contentPotential, 5);
    expect(fetched.noAppNeeded, isTrue);
    expect(fetched.steps, ['Open settings', 'Connect Wi-Fi']);
  });

  test('Toggles favorite status on a treasure', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'fav_test',
      title: 'WhatsApp Storage Cleaner',
      shortDescription: 'Free up phone memory',
      categoryId: 'cat_whatsapp',
      isFavorite: false,
      createdAt: now,
      updatedAt: now,
    );

    await repository.createTreasure(treasure);

    // Toggle favorite to true
    final toggle1 = await repository.toggleFavorite('fav_test');
    expect(toggle1.isSuccess, isTrue);
    expect(toggle1.valueOrNull, isTrue);

    // Toggle favorite back to false
    final toggle2 = await repository.toggleFavorite('fav_test');
    expect(toggle2.isSuccess, isTrue);
    expect(toggle2.valueOrNull, isFalse);
  });

  test('Updates lifecycle status in pipeline', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'status_test',
      title: 'Windows God Mode Shortcut',
      shortDescription: 'All settings in one folder',
      categoryId: 'cat_windows',
      status: TreasureStatus.idea,
      createdAt: now,
      updatedAt: now,
    );

    await repository.createTreasure(treasure);

    final updateResult = await repository.updateStatus('status_test', TreasureStatus.verified);
    expect(updateResult.isSuccess, isTrue);

    final fetched = (await repository.getTreasureById('status_test')).valueOrNull!;
    expect(fetched.status, TreasureStatus.verified);
  });

  test('Filters treasures by category and search query', () async {
    final now = DateTime.now();
    await repository.createTreasure(
      TreasureEntity(
        id: '1',
        title: 'Android Clipboard Sync',
        shortDescription: 'Sync with PC',
        categoryId: 'cat_phone_pc',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repository.createTreasure(
      TreasureEntity(
        id: '2',
        title: 'WhatsApp Privacy Lock',
        shortDescription: 'Lock individual chats',
        categoryId: 'cat_whatsapp',
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Filter by category
    final phonePcOnly = await repository.getTreasures(
      filter: const TreasureFilter(categoryId: 'cat_phone_pc'),
    );
    expect(phonePcOnly.valueOrNull!.length, 1);
    expect(phonePcOnly.valueOrNull!.first.title, 'Android Clipboard Sync');

    // Filter by search query
    final searchResult = await repository.getTreasures(
      filter: const TreasureFilter(searchQuery: 'Privacy'),
    );
    expect(searchResult.valueOrNull!.length, 1);
    expect(searchResult.valueOrNull!.first.id, '2');
  });

  test('Deletes a treasure successfully', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'del_test',
      title: 'Temp Trick',
      shortDescription: 'To be deleted',
      categoryId: 'cat_other',
      createdAt: now,
      updatedAt: now,
    );

    await repository.createTreasure(treasure);
    expect((await repository.getTotalCount()).valueOrNull, 1);

    await repository.deleteTreasure('del_test');
    expect((await repository.getTotalCount()).valueOrNull, 0);
  });
}

