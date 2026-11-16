import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';

class TestsDao {
  final AppDatabase db;

  TestsDao(this.db);

  Stream<List<TestRecord>> watchTests(String treasureId) {
    return (db.select(db.testRecords)
          ..where((t) => t.treasureId.equals(treasureId))
          ..orderBy([(t) => OrderingTerm.desc(t.testedAt)]))
        .watch();
  }

  Future<List<TestRecord>> getTests(String treasureId) {
    return (db.select(db.testRecords)
          ..where((t) => t.treasureId.equals(treasureId))
          ..orderBy([(t) => OrderingTerm.desc(t.testedAt)]))
        .get();
  }

  Future<void> insertTestRecord(TestRecordsCompanion companion) async {
    await db.into(db.testRecords).insert(companion);
  }

  Future<int> deleteTestRecord(String id) async {
    return (db.delete(db.testRecords)..where((t) => t.id.equals(id))).go();
  }
}

