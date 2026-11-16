import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  CategoryRepositoryImpl(this._db);

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return (_db.select(_db.categories)..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch()
        .map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<Result<List<CategoryEntity>, Failure>> getCategories() async {
    try {
      final rows = await (_db.select(_db.categories)..orderBy([(c) => OrderingTerm.asc(c.name)])).get();
      return Success(rows.map(_mapToEntity).toList());
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to load categories: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<CategoryEntity, Failure>> getCategoryById(String id) async {
    try {
      final row = await (_db.select(_db.categories)..where((c) => c.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return FailureResult(NotFoundFailure('Category $id not found'));
      }
      return Success(_mapToEntity(row));
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to load category: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<String, Failure>> createCategory(CategoryEntity category) async {
    try {
      final id = category.id.isNotEmpty ? category.id : _uuid.v4();
      final now = DateTime.now();

      await _db.into(_db.categories).insert(
            CategoriesCompanion.insert(
              id: id,
              name: category.name,
              description: Value(category.description),
              icon: category.icon,
              isDefault: Value(category.isDefault),
              createdAt: now,
            ),
          );
      return Success(id);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to create category: $e', cause: e, stackTrace: st));
    }
  }

  CategoryEntity _mapToEntity(Category row) {
    return CategoryEntity(
      id: row.id,
      name: row.name,
      description: row.description,
      icon: row.icon,
      isDefault: row.isDefault,
      createdAt: row.createdAt,
    );
  }
}

