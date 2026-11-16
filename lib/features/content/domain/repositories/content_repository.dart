import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/content_entity.dart';
import '../entities/content_metrics_entity.dart';

/// Contract for managing creator scripts, production pipelines, and analytics.
abstract class ContentRepository {
  /// Stream the content script/details for a specific treasure.
  Stream<ContentEntity?> watchContentForTreasure(String treasureId);

  /// Fetch current content script/details for a specific treasure.
  Future<Result<ContentEntity?, Failure>> getContentForTreasure(String treasureId);

  /// Create or update a content deliverable. Returns the content ID.
  Future<Result<String, Failure>> saveContent(ContentEntity content);

  /// Update the workflow status of a content deliverable.
  Future<Result<void, Failure>> updateContentStatus(String contentId, String status);

  /// Record an empirical performance metrics snapshot.
  Future<Result<String, Failure>> recordMetrics(ContentMetricsEntity metrics);

  /// Watch performance metrics timeline for a content deliverable.
  Stream<List<ContentMetricsEntity>> watchMetricsForContent(String contentId);

  /// Get historical performance metrics snapshots for a content deliverable.
  Future<Result<List<ContentMetricsEntity>, Failure>> getMetricsForContent(String contentId);

  /// Remove a content deliverable.
  Future<Result<void, Failure>> deleteContent(String id);
}

