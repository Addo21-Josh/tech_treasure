import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/content_entity.dart';
import '../../domain/entities/content_metrics_entity.dart';
import '../../domain/repositories/content_repository.dart';
import '../daos/contents_dao.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentsDao _dao;
  final _uuid = const Uuid();

  ContentRepositoryImpl(this._dao);

  @override
  Stream<ContentEntity?> watchContentForTreasure(String treasureId) {
    return _dao
        .watchContentForTreasure(treasureId)
        .map((row) => row != null ? _mapContent(row) : null);
  }

  @override
  Future<Result<ContentEntity?, Failure>> getContentForTreasure(
    String treasureId,
  ) async {
    try {
      final row = await _dao.getContentForTreasure(treasureId);
      return Success(row != null ? _mapContent(row) : null);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to load content for treasure: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<String, Failure>> saveContent(ContentEntity content) async {
    try {
      final id = content.id.isNotEmpty ? content.id : _uuid.v4();
      final now = DateTime.now();

      final companion = ContentsCompanion(
        id: Value(id),
        treasureId: Value(content.treasureId),
        contentType: Value(content.contentType.name),
        hook: Value(content.hook),
        problem: Value(content.problem),
        demonstration: Value(content.demonstration),
        script: Value(content.script),
        cta: Value(content.cta),
        status: Value(content.status),
        platformUrl: Value(content.platformUrl),
        publishedAt: Value(content.publishedAt),
        createdAt: Value(content.createdAt),
        updatedAt: Value(now),
      );

      await _dao.upsertContent(companion);
      return Success(id);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure('Failed to save content: $e', cause: e, stackTrace: st),
      );
    }
  }

  @override
  Future<Result<void, Failure>> updateContentStatus(
    String contentId,
    String status,
  ) async {
    try {
      await _dao.updateStatus(contentId, status, DateTime.now());
      return const Success(null);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to update content status: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<String, Failure>> recordMetrics(
    ContentMetricsEntity metrics,
  ) async {
    try {
      final id = metrics.id.isNotEmpty ? metrics.id : _uuid.v4();
      final companion = ContentMetricsCompanion.insert(
        id: id,
        contentId: metrics.contentId,
        views: Value(metrics.views),
        likes: Value(metrics.likes),
        comments: Value(metrics.comments),
        shares: Value(metrics.shares),
        saves: Value(metrics.saves),
        followersGained: Value(metrics.followersGained),
        performanceNotes: Value(metrics.performanceNotes),
        recordedAt: metrics.recordedAt,
      );

      await _dao.insertMetric(companion);
      return Success(id);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to record metrics: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Stream<List<ContentMetricsEntity>> watchMetricsForContent(String contentId) {
    return _dao
        .watchMetrics(contentId)
        .map((rows) => rows.map(_mapMetric).toList());
  }

  @override
  Future<Result<List<ContentMetricsEntity>, Failure>> getMetricsForContent(
    String contentId,
  ) async {
    try {
      final rows = await _dao.getMetrics(contentId);
      return Success(rows.map(_mapMetric).toList());
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure('Failed to get metrics: $e', cause: e, stackTrace: st),
      );
    }
  }

  @override
  Future<Result<void, Failure>> deleteContent(String id) async {
    try {
      await _dao.deleteContent(id);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to delete content: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  ContentEntity _mapContent(Content row) {
    final contentType = ContentType.values.firstWhere(
      (e) => e.name == row.contentType,
      orElse: () => ContentType.youtubeShort,
    );

    return ContentEntity(
      id: row.id,
      treasureId: row.treasureId,
      contentType: contentType,
      hook: row.hook,
      problem: row.problem,
      demonstration: row.demonstration,
      script: row.script,
      cta: row.cta,
      status: row.status,
      platformUrl: row.platformUrl,
      publishedAt: row.publishedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ContentMetricsEntity _mapMetric(ContentMetric row) {
    return ContentMetricsEntity(
      id: row.id,
      contentId: row.contentId,
      views: row.views,
      likes: row.likes,
      comments: row.comments,
      shares: row.shares,
      saves: row.saves,
      followersGained: row.followersGained,
      performanceNotes: row.performanceNotes,
      recordedAt: row.recordedAt,
    );
  }
}
