import '../../../../core/constants/app_enums.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/treasure_entity.dart';
import '../entities/treasure_filter.dart';

/// Abstract repository contract for Treasure persistence operations.
abstract class TreasureRepository {
  /// Watches a reactive stream of treasures filtered according to [filter].
  Stream<List<TreasureEntity>> watchTreasures({TreasureFilter? filter});

  /// Fetches a one-time list of treasures.
  Future<Result<List<TreasureEntity>, Failure>> getTreasures({TreasureFilter? filter});

  /// Fetches a single treasure by its unique identifier.
  Future<Result<TreasureEntity, Failure>> getTreasureById(String id);

  /// Creates a new treasure and returns its unique ID.
  Future<Result<String, Failure>> createTreasure(TreasureEntity treasure);

  /// Updates an existing treasure.
  Future<Result<void, Failure>> updateTreasure(TreasureEntity treasure);

  /// Deletes a treasure by ID with cascading delete on related records.
  Future<Result<void, Failure>> deleteTreasure(String id);

  /// Toggles the favorite flag on a treasure and returns the new favorite status.
  Future<Result<bool, Failure>> toggleFavorite(String id);

  /// Fast-advances or changes a treasure's pipeline lifecycle status.
  Future<Result<void, Failure>> updateStatus(String id, TreasureStatus status);

  /// Retrieves counts of treasures grouped by lifecycle status for dashboard metrics.
  Future<Result<Map<TreasureStatus, int>, Failure>> getStatusCounts();

  /// Watches reactive counts of treasures per status.
  Stream<Map<TreasureStatus, int>> watchStatusCounts();

  /// Retrieves the total count of all treasures in the database.
  Future<Result<int, Failure>> getTotalCount();

  /// Searches treasures with sub-millisecond full-text matching.
  Future<Result<List<TreasureEntity>, Failure>> searchTreasures(String queryText);
}

