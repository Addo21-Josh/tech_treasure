import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/daos/tags_dao.dart';
import '../../data/daos/treasures_dao.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/tag_repository_impl.dart';
import '../../data/repositories/treasure_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/entities/treasure_entity.dart';
import '../../domain/entities/treasure_filter.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../../domain/repositories/treasure_repository.dart';

/// Provider for TreasuresDao.
final treasuresDaoProvider = Provider<TreasuresDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TreasuresDao(db);
});

/// Provider for TagsDao.
final tagsDaoProvider = Provider<TagsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TagsDao(db);
});

/// Provider for TagRepository.
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final dao = ref.watch(tagsDaoProvider);
  return TagRepositoryImpl(dao);
});

/// Reactive stream of all unique tags in the system.
final allTagsStreamProvider = StreamProvider<List<TagEntity>>((ref) {
  final repo = ref.watch(tagRepositoryProvider);
  return repo.watchAllTags();
});

/// Provider for TreasureRepository.
final treasureRepositoryProvider = Provider<TreasureRepository>((ref) {
  final dao = ref.watch(treasuresDaoProvider);
  return TreasureRepositoryImpl(dao);
});

/// Provider for CategoryRepository.
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CategoryRepositoryImpl(db);
});

/// Reactive stream of all categories.
final categoriesStreamProvider = StreamProvider<List<CategoryEntity>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchCategories();
});

/// Mutable state provider holding the active list filter.
final treasureFilterProvider = StateProvider<TreasureFilter>((ref) {
  return const TreasureFilter();
});

/// Active search query string for offline search.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Real-time debounced search results using SQLite FTS5.
final searchResultsProvider = FutureProvider<List<TreasureEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return const [];

  final repo = ref.watch(treasureRepositoryProvider);
  final result = await repo.searchTreasures(query);
  return result.fold(onSuccess: (items) => items, onFailure: (_) => const []);
});

/// Reactive stream of treasures based on active filter.
final treasuresStreamProvider = StreamProvider<List<TreasureEntity>>((ref) {
  final repo = ref.watch(treasureRepositoryProvider);
  final filter = ref.watch(treasureFilterProvider);
  return repo.watchTreasures(filter: filter);
});

/// Reactive single treasure stream by ID.
final treasureDetailStreamProvider =
    StreamProvider.family<TreasureEntity?, String>((ref, id) {
      final repo = ref.watch(treasureRepositoryProvider);
      return repo.watchTreasures().map((list) {
        return list.where((t) => t.id == id).firstOrNull;
      });
    });

/// Reactive stream of counts per status for the dashboard.
final statusCountsStreamProvider = StreamProvider<Map<TreasureStatus, int>>((
  ref,
) {
  final repo = ref.watch(treasureRepositoryProvider);
  return repo.watchStatusCounts();
});

/// Total count of all treasures.
final totalTreasuresCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(treasureRepositoryProvider);
  final result = await repo.getTotalCount();
  return result.fold(onSuccess: (count) => count, onFailure: (_) => 0);
});
