import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/source_entity.dart';
import '../../domain/repositories/source_repository.dart';
import '../daos/sources_dao.dart';

class SourceRepositoryImpl implements SourceRepository {
  final SourcesDao _dao;
  final _uuid = const Uuid();

  SourceRepositoryImpl(this._dao);

  @override
  Stream<List<SourceEntity>> watchSourcesForTreasure(String treasureId) {
    return _dao.watchSources(treasureId).map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<Result<List<SourceEntity>, Failure>> getSourcesForTreasure(String treasureId) async {
    try {
      final rows = await _dao.getSources(treasureId);
      return Success(rows.map(_mapToEntity).toList());
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to fetch sources: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<String, Failure>> addSource(SourceEntity source) async {
    try {
      final id = source.id.isNotEmpty ? source.id : _uuid.v4();
      final now = DateTime.now();

      final companion = SourcesCompanion.insert(
        id: id,
        treasureId: source.treasureId,
        title: source.title,
        url: Value(source.url),
        sourceType: source.sourceType.name,
        notes: Value(source.notes),
        createdAt: now,
      );

      await _dao.insertSource(companion);
      return Success(id);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to insert source: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<void, Failure>> deleteSource(String id) async {
    try {
      await _dao.deleteSource(id);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to delete source: $e', cause: e, stackTrace: st));
    }
  }

  SourceEntity _mapToEntity(Source row) {
    return SourceEntity(
      id: row.id,
      treasureId: row.treasureId,
      title: row.title,
      url: row.url,
      sourceType: SourceType.values.firstWhere(
        (s) => s.name == row.sourceType,
        orElse: () => SourceType.other,
      ),
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }
}

