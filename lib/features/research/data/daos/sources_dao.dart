import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';

class SourcesDao {
  final AppDatabase db;

  SourcesDao(this.db);

  Stream<List<Source>> watchSources(String treasureId) {
    return (db.select(db.sources)
          ..where((s) => s.treasureId.equals(treasureId))
          ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
        .watch();
  }

  Future<List<Source>> getSources(String treasureId) {
    return (db.select(db.sources)
          ..where((s) => s.treasureId.equals(treasureId))
          ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
        .get();
  }

  Future<void> insertSource(SourcesCompanion companion) async {
    await db.into(db.sources).insert(companion);
  }

  Future<int> deleteSource(String id) async {
    return (db.delete(db.sources)..where((s) => s.id.equals(id))).go();
  }
}
