import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/daos/tests_dao.dart';
import '../../data/repositories/test_repository_impl.dart';
import '../../domain/entities/test_record_entity.dart';
import '../../domain/repositories/test_repository.dart';

final testsDaoProvider = Provider<TestsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TestsDao(db);
});

final testRepositoryProvider = Provider<TestRepository>((ref) {
  final dao = ref.watch(testsDaoProvider);
  return TestRepositoryImpl(dao);
});

final testsStreamProvider =
    StreamProvider.family<List<TestRecordEntity>, String>((ref, treasureId) {
      final repo = ref.watch(testRepositoryProvider);
      return repo.watchTestsForTreasure(treasureId);
    });
