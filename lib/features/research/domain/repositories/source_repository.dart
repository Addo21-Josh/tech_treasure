import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/source_entity.dart';

abstract class SourceRepository {
  Stream<List<SourceEntity>> watchSourcesForTreasure(String treasureId);
  Future<Result<List<SourceEntity>, Failure>> getSourcesForTreasure(
    String treasureId,
  );
  Future<Result<String, Failure>> addSource(SourceEntity source);
  Future<Result<void, Failure>> deleteSource(String id);
}
