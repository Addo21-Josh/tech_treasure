import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/tag_entity.dart';

class TagsDao {
  final AppDatabase db;
  final _uuid = const Uuid();

  TagsDao(this.db);

  Stream<List<Tag>> watchAllTags() {
    return (db.select(db.tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  Future<List<Tag>> getAllTags() {
    return (db.select(db.tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Future<List<Tag>> getTagsForTreasure(String treasureId) async {
    final query = db.select(db.tags).join([
      innerJoin(
        db.treasureTags,
        db.treasureTags.tagId.equalsExp(db.tags.id),
      ),
    ])..where(db.treasureTags.treasureId.equals(treasureId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(db.tags)).toList();
  }

  Future<void> setTagsForTreasure(String treasureId, List<String> tagNames) async {
    await db.transaction(() async {
      // 1. Clear existing associations for this treasure
      await (db.delete(db.treasureTags)..where((t) => t.treasureId.equals(treasureId))).go();

      // 2. Insert new associations
      for (final rawName in tagNames) {
        final normalized = TagEntity.normalize(rawName);
        if (normalized == '#' || normalized.isEmpty) continue;

        // Check if tag already exists (case-insensitive)
        var existingTag = await (db.select(db.tags)
              ..where((t) => t.name.equals(normalized)))
            .getSingleOrNull();

        if (existingTag == null) {
          final newTagId = _uuid.v4();
          await db.into(db.tags).insert(
                TagsCompanion.insert(
                  id: newTagId,
                  name: normalized,
                  createdAt: DateTime.now(),
                ),
              );
          existingTag = Tag(id: newTagId, name: normalized, createdAt: DateTime.now());
        }

        // Link in junction table
        await db.into(db.treasureTags).insertOnConflictUpdate(
              TreasureTagsCompanion.insert(
                treasureId: treasureId,
                tagId: existingTag.id,
              ),
            );
      }
    });
  }

  Future<Tag> getOrCreateTag(String rawName) async {
    final normalized = TagEntity.normalize(rawName);
    final existing = await (db.select(db.tags)..where((t) => t.name.equals(normalized))).getSingleOrNull();
    if (existing != null) return existing;

    final newTagId = _uuid.v4();
    final now = DateTime.now();
    await db.into(db.tags).insert(
          TagsCompanion.insert(
            id: newTagId,
            name: normalized,
            createdAt: now,
          ),
        );
    return Tag(id: newTagId, name: normalized, createdAt: now);
  }
}

