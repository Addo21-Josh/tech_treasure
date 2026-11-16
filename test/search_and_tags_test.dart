import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_treasure/core/database/app_database.dart';
import 'package:tech_treasure/features/treasures/data/daos/tags_dao.dart';
import 'package:tech_treasure/features/treasures/data/daos/treasures_dao.dart';
import 'package:tech_treasure/features/treasures/data/repositories/category_repository_impl.dart';
import 'package:tech_treasure/features/treasures/data/repositories/tag_repository_impl.dart';
import 'package:tech_treasure/features/treasures/data/repositories/treasure_repository_impl.dart';
import 'package:tech_treasure/features/treasures/domain/entities/category_entity.dart';
import 'package:tech_treasure/features/treasures/domain/entities/treasure_entity.dart';

void main() {
  late AppDatabase db;
  late TreasuresDao treasuresDao;
  late TagsDao tagsDao;
  late TreasureRepositoryImpl treasureRepo;
  late CategoryRepositoryImpl categoryRepo;
  late TagRepositoryImpl tagRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    treasuresDao = TreasuresDao(db);
    tagsDao = TagsDao(db);
    treasureRepo = TreasureRepositoryImpl(treasuresDao);
    categoryRepo = CategoryRepositoryImpl(db);
    tagRepo = TagRepositoryImpl(tagsDao);
  });

  tearDown(() async {
    await db.close();
  });

  test('Creates custom category and retrieves all categories', () async {
    final cat = CategoryEntity(
      id: 'cat_custom_ai',
      name: 'AI Productivity',
      description: 'Prompts and automation workflows',
      icon: 'auto_awesome',
      createdAt: DateTime.now(),
    );

    final createResult = await categoryRepo.createCategory(cat);
    expect(createResult.isSuccess, isTrue);

    final listResult = await categoryRepo.getCategories();
    expect(listResult.isSuccess, isTrue);
    final categories = listResult.valueOrNull!;
    expect(categories.any((c) => c.name == 'AI Productivity'), isTrue);
  });

  test('Associates tags with a treasure and retrieves them', () async {
    final now = DateTime.now();
    final treasure = TreasureEntity(
      id: 'tr_tag_test',
      title: 'WhatsApp Storage Cleaner',
      shortDescription: 'Free up phone memory',
      categoryId: 'cat_whatsapp',
      createdAt: now,
      updatedAt: now,
    );

    await treasureRepo.createTreasure(treasure);

    // Set tags
    final setTagsResult = await tagRepo.setTagsForTreasure(
      'tr_tag_test',
      ['#whatsapp', 'storage', '#offline'],
    );
    expect(setTagsResult.isSuccess, isTrue);

    // Retrieve tags
    final tagsResult = await tagRepo.getTagsForTreasure('tr_tag_test');
    expect(tagsResult.isSuccess, isTrue);
    final tags = tagsResult.valueOrNull!;
    expect(tags.length, 3);
    expect(tags.map((t) => t.name).toList(), containsAll(['#whatsapp', '#storage', '#offline']));
  });

  test('Performs search query matching title and short description', () async {
    final now = DateTime.now();
    await treasureRepo.createTreasure(
      TreasureEntity(
        id: 'mouse_trick',
        title: 'Android Phone as Trackpad',
        shortDescription: 'Replace your dead computer mouse wirelessly',
        categoryId: 'cat_phone_pc',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final searchResult = await treasureRepo.searchTreasures('Trackpad');
    expect(searchResult.isSuccess, isTrue);
    final results = searchResult.valueOrNull!;
    expect(results.length, 1);
    expect(results.first.title, 'Android Phone as Trackpad');
  });
}

