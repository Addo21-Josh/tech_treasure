import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';

/// Data Access Object for contents and content metrics tables.
class ContentsDao {
  final AppDatabase db;

  ContentsDao(this.db);

  Stream<Content?> watchContentForTreasure(String treasureId) {
    return (db.select(db.contents)..where((c) => c.treasureId.equals(treasureId)))
        .watchSingleOrNull();
  }

  Future<Content?> getContentForTreasure(String treasureId) {
    return (db.select(db.contents)..where((c) => c.treasureId.equals(treasureId)))
        .getSingleOrNull();
  }

  Future<Content?> getContentById(String id) {
    return (db.select(db.contents)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertContent(ContentsCompanion companion) async {
    await db.into(db.contents).insertOnConflictUpdate(companion);
  }

  Future<int> updateStatus(String id, String status, DateTime now) async {
    return (db.update(db.contents)..where((c) => c.id.equals(id))).write(
      ContentsCompanion(
        status: Value(status),
        updatedAt: Value(now),
      ),
    );
  }

  Future<int> deleteContent(String id) async {
    return (db.delete(db.contents)..where((c) => c.id.equals(id))).go();
  }

  // --- Metrics ---

  Stream<List<ContentMetric>> watchMetrics(String contentId) {
    return (db.select(db.contentMetrics)
          ..where((m) => m.contentId.equals(contentId))
          ..orderBy([(m) => OrderingTerm.desc(m.recordedAt)]))
        .watch();
  }

  Future<List<ContentMetric>> getMetrics(String contentId) {
    return (db.select(db.contentMetrics)
          ..where((m) => m.contentId.equals(contentId))
          ..orderBy([(m) => OrderingTerm.desc(m.recordedAt)]))
        .get();
  }

  Future<void> insertMetric(ContentMetricsCompanion companion) async {
    await db.into(db.contentMetrics).insert(companion);
  }
}

