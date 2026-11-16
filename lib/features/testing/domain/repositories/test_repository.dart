import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/test_record_entity.dart';

abstract class TestRepository {
  Stream<List<TestRecordEntity>> watchTestsForTreasure(String treasureId);
  Future<Result<List<TestRecordEntity>, Failure>> getTestsForTreasure(
    String treasureId,
  );
  Future<Result<String, Failure>> addTestRecord(TestRecordEntity testRecord);
  Future<Result<void, Failure>> deleteTestRecord(String id);
}
