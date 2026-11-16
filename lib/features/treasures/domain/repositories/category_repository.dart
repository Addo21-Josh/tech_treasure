import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Stream<List<CategoryEntity>> watchCategories();
  Future<Result<List<CategoryEntity>, Failure>> getCategories();
  Future<Result<CategoryEntity, Failure>> getCategoryById(String id);
  Future<Result<String, Failure>> createCategory(CategoryEntity category);
}
