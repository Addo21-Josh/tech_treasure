import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/test_record_entity.dart';
import '../../domain/repositories/test_repository.dart';
import '../daos/tests_dao.dart';

class TestRepositoryImpl implements TestRepository {
  final TestsDao _dao;
  final _uuid = const Uuid();

  TestRepositoryImpl(this._dao);

  @override
  Stream<List<TestRecordEntity>> watchTestsForTreasure(String treasureId) {
    return _dao
        .watchTests(treasureId)
        .map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<Result<List<TestRecordEntity>, Failure>> getTestsForTreasure(
    String treasureId,
  ) async {
    try {
      final rows = await _dao.getTests(treasureId);
      return Success(rows.map(_mapToEntity).toList());
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to fetch test records: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<String, Failure>> addTestRecord(
    TestRecordEntity testRecord,
  ) async {
    try {
      final id = testRecord.id.isNotEmpty ? testRecord.id : _uuid.v4();

      final companion = TestRecordsCompanion.insert(
        id: id,
        treasureId: testRecord.treasureId,
        device: testRecord.device,
        osVersion: testRecord.osVersion,
        environment: Value(testRecord.environment),
        result: testRecord.result.name,
        notes: Value(testRecord.notes),
        testedAt: testRecord.testedAt,
      );

      await _dao.insertTestRecord(companion);
      return Success(id);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to add test record: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<void, Failure>> deleteTestRecord(String id) async {
    try {
      await _dao.deleteTestRecord(id);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to delete test record: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  TestRecordEntity _mapToEntity(TestRecord row) {
    return TestRecordEntity(
      id: row.id,
      treasureId: row.treasureId,
      device: row.device,
      osVersion: row.osVersion,
      environment: row.environment,
      result: TestResult.values.firstWhere(
        (r) => r.name == row.result,
        orElse: () => TestResult.works,
      ),
      notes: row.notes,
      testedAt: row.testedAt,
    );
  }
}
