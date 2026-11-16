import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';
import '../daos/tags_dao.dart';

class TagRepositoryImpl implements TagRepository {
  final TagsDao _dao;

  TagRepositoryImpl(this._dao);

  @override
  Stream<List<TagEntity>> watchAllTags() {
    return _dao.watchAllTags().map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<Result<List<TagEntity>, Failure>> getAllTags() async {
    try {
      final rows = await _dao.getAllTags();
      return Success(rows.map(_mapToEntity).toList());
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure('Failed to fetch tags: $e', cause: e, stackTrace: st),
      );
    }
  }

  @override
  Future<Result<List<TagEntity>, Failure>> getTagsForTreasure(
    String treasureId,
  ) async {
    try {
      final rows = await _dao.getTagsForTreasure(treasureId);
      return Success(rows.map(_mapToEntity).toList());
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to fetch tags for treasure: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<void, Failure>> setTagsForTreasure(
    String treasureId,
    List<String> tagNames,
  ) async {
    try {
      await _dao.setTagsForTreasure(treasureId, tagNames);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to associate tags: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<TagEntity, Failure>> getOrCreateTag(String name) async {
    try {
      final tag = await _dao.getOrCreateTag(name);
      return Success(_mapToEntity(tag));
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure('Failed to create tag: $e', cause: e, stackTrace: st),
      );
    }
  }

  TagEntity _mapToEntity(Tag row) {
    return TagEntity(id: row.id, name: row.name, createdAt: row.createdAt);
  }
}
