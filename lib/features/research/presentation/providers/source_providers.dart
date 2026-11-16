import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/daos/sources_dao.dart';
import '../../data/repositories/source_repository_impl.dart';
import '../../domain/entities/source_entity.dart';
import '../../domain/repositories/source_repository.dart';

final sourcesDaoProvider = Provider<SourcesDao>((ref) {
  final db = ref.watch(databaseProvider);
  return SourcesDao(db);
});

final sourceRepositoryProvider = Provider<SourceRepository>((ref) {
  final dao = ref.watch(sourcesDaoProvider);
  return SourceRepositoryImpl(dao);
});

final sourcesStreamProvider = StreamProvider.family<List<SourceEntity>, String>((ref, treasureId) {
  final repo = ref.watch(sourceRepositoryProvider);
  return repo.watchSourcesForTreasure(treasureId);
});

