import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/daos/contents_dao.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../domain/entities/content_entity.dart';
import '../../domain/entities/content_metrics_entity.dart';
import '../../domain/repositories/content_repository.dart';

final contentsDaoProvider = Provider<ContentsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ContentsDao(db);
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final dao = ref.watch(contentsDaoProvider);
  return ContentRepositoryImpl(dao);
});

final contentForTreasureProvider =
    StreamProvider.family<ContentEntity?, String>((ref, treasureId) {
  final repo = ref.watch(contentRepositoryProvider);
  return repo.watchContentForTreasure(treasureId);
});

final metricsForContentProvider =
    StreamProvider.family<List<ContentMetricsEntity>, String>((ref, contentId) {
  final repo = ref.watch(contentRepositoryProvider);
  return repo.watchMetricsForContent(contentId);
});

