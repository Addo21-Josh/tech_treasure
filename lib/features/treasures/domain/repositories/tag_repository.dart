import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/tag_entity.dart';

/// Abstract repository contract for managing tags and treasure-tag associations.
abstract class TagRepository {
  /// Watches a reactive stream of all unique tags in the system.
  Stream<List<TagEntity>> watchAllTags();

  /// Gets all tags sorted by name.
  Future<Result<List<TagEntity>, Failure>> getAllTags();

  /// Gets tags assigned to a specific treasure.
  Future<Result<List<TagEntity>, Failure>> getTagsForTreasure(
    String treasureId,
  );

  /// Synchronizes the set of tags for a treasure (creating new tags if needed).
  Future<Result<void, Failure>> setTagsForTreasure(
    String treasureId,
    List<String> tagNames,
  );

  /// Retrieves an existing tag by name or creates it if it does not exist.
  Future<Result<TagEntity, Failure>> getOrCreateTag(String name);
}
