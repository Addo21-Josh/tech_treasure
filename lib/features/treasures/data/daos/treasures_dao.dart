import 'package:drift/drift.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/treasure_filter.dart';

/// Raw record pairing a TreasureRow with its CategoryRow.
class TreasureWithCategory {
  final Treasure treasure;
  final Category? category;

  const TreasureWithCategory({
    required this.treasure,
    this.category,
  });
}

/// Data Access Object handling SQLite queries for Treasures.
class TreasuresDao {
  final AppDatabase db;

  TreasuresDao(this.db);

  /// Watches a reactive stream of treasures with joined category information.
  Stream<List<TreasureWithCategory>> watchTreasures({TreasureFilter? filter}) {
    final query = db.select(db.treasures).join([
      leftOuterJoin(
        db.categories,
        db.categories.id.equalsExp(db.treasures.categoryId),
      ),
    ]);

    _applyFilter(query, filter);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TreasureWithCategory(
          treasure: row.readTable(db.treasures),
          category: row.readTableOrNull(db.categories),
        );
      }).toList();
    });
  }

  /// Fetches a one-time list of treasures with joined category.
  Future<List<TreasureWithCategory>> getTreasures({TreasureFilter? filter}) async {
    final query = db.select(db.treasures).join([
      leftOuterJoin(
        db.categories,
        db.categories.id.equalsExp(db.treasures.categoryId),
      ),
    ]);

    _applyFilter(query, filter);

    final rows = await query.get();
    return rows.map((row) {
      return TreasureWithCategory(
        treasure: row.readTable(db.treasures),
        category: row.readTableOrNull(db.categories),
      );
    }).toList();
  }

  /// Fetches a single treasure by ID with its joined category.
  Future<TreasureWithCategory?> getTreasureById(String id) async {
    final query = db.select(db.treasures).join([
      leftOuterJoin(
        db.categories,
        db.categories.id.equalsExp(db.treasures.categoryId),
      ),
    ])..where(db.treasures.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return TreasureWithCategory(
      treasure: row.readTable(db.treasures),
      category: row.readTableOrNull(db.categories),
    );
  }

  /// Inserts a new treasure record.
  Future<void> insertTreasure(TreasuresCompanion companion) async {
    await db.into(db.treasures).insert(companion);
  }

  /// Updates an existing treasure record.
  Future<void> updateTreasure(TreasuresCompanion companion) async {
    await db.update(db.treasures).replace(companion);
  }

  /// Deletes a treasure record by ID (foreign keys cascade delete child sources/tests).
  Future<int> deleteTreasure(String id) async {
    return (db.delete(db.treasures)..where((t) => t.id.equals(id))).go();
  }

  /// Toggles the isFavorite boolean on a treasure.
  Future<bool> toggleFavorite(String id) async {
    final current = await (db.select(db.treasures)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (current == null) return false;

    final newStatus = !current.isFavorite;
    await (db.update(db.treasures)..where((t) => t.id.equals(id))).write(
      TreasuresCompanion(
        isFavorite: Value(newStatus),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return newStatus;
  }

  /// Fast-advances or updates the lifecycle status of a treasure.
  Future<void> updateStatus(String id, String status) async {
    await (db.update(db.treasures)..where((t) => t.id.equals(id))).write(
      TreasuresCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Watches counts of treasures grouped by status.
  Stream<Map<TreasureStatus, int>> watchStatusCounts() {
    return db.select(db.treasures).watch().map((all) {
      final counts = <TreasureStatus, int>{
        for (final s in TreasureStatus.values) s: 0,
      };
      for (final t in all) {
        final status = _parseStatus(t.status);
        counts[status] = (counts[status] ?? 0) + 1;
      }
      return counts;
    });
  }

  /// Gets one-time counts of treasures grouped by status.
  Future<Map<TreasureStatus, int>> getStatusCounts() async {
    final all = await db.select(db.treasures).get();
    final counts = <TreasureStatus, int>{
      for (final s in TreasureStatus.values) s: 0,
    };
    for (final t in all) {
      final status = _parseStatus(t.status);
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  /// Gets the total count of all treasures.
  Future<int> getTotalCount() async {
    final countExp = db.treasures.id.count();
    final query = db.selectOnly(db.treasures)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  /// Runs sub-millisecond full-text search using SQLite FTS5 with fallback.
  Future<List<TreasureWithCategory>> searchTreasures(String queryText) async {
    final clean = queryText.trim();
    if (clean.isEmpty) return const [];

    try {
      final ftsQuery = clean.replaceAll(RegExp(r'[^a-zA-Z0-9_\*]'), ' ').trim();
      if (ftsQuery.isNotEmpty) {
        final ftsSearchTerm = '$ftsQuery*';
        final rows = await db.customSelect(
          'SELECT id FROM treasures_fts WHERE treasures_fts MATCH ?',
          variables: [Variable.withString(ftsSearchTerm)],
        ).get();

        if (rows.isNotEmpty) {
          final ids = rows.map((r) => r.read<String>('id')).toList();
          final query = db.select(db.treasures).join([
            leftOuterJoin(db.categories, db.categories.id.equalsExp(db.treasures.categoryId)),
          ])..where(db.treasures.id.isIn(ids));
          final results = await query.get();
          return results.map((row) => TreasureWithCategory(
                treasure: row.readTable(db.treasures),
                category: row.readTableOrNull(db.categories),
              )).toList();
        }
      }
    } catch (_) {
      // Fallback to pattern match
    }

    return getTreasures(filter: TreasureFilter(searchQuery: clean));
  }

  void _applyFilter(
    JoinedSelectStatement<HasResultSet, dynamic> query,
    TreasureFilter? filter,
  ) {
    if (filter == null) {
      query.orderBy([OrderingTerm.desc(db.treasures.updatedAt)]);
      return;
    }

    if (filter.categoryId != null) {
      query.where(db.treasures.categoryId.equals(filter.categoryId!));
    }
    if (filter.status != null) {
      query.where(db.treasures.status.equals(filter.status!.name));
    }
    if (filter.isVerified != null) {
      query.where(db.treasures.isVerified.equals(filter.isVerified!));
    }
    if (filter.isFavorite != null) {
      query.where(db.treasures.isFavorite.equals(filter.isFavorite!));
    }
    if (filter.noAppNeeded != null) {
      query.where(db.treasures.noAppNeeded.equals(filter.noAppNeeded!));
    }
    if (filter.minPotential != null) {
      query.where(db.treasures.contentPotential.isBiggerOrEqualValue(filter.minPotential!));
    }
    if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
      final searchPattern = '%${filter.searchQuery!.trim()}%';
      query.where(
        db.treasures.title.like(searchPattern) |
            db.treasures.shortDescription.like(searchPattern) |
            db.treasures.problem.like(searchPattern) |
            db.treasures.solution.like(searchPattern),
      );
    }

    switch (filter.sortBy) {
      case TreasureSortBy.recentlyUpdated:
        query.orderBy([OrderingTerm.desc(db.treasures.updatedAt)]);
      case TreasureSortBy.recentlyCreated:
        query.orderBy([OrderingTerm.desc(db.treasures.createdAt)]);
      case TreasureSortBy.highestPotential:
        query.orderBy([OrderingTerm.desc(db.treasures.contentPotential)]);
      case TreasureSortBy.titleAsc:
        query.orderBy([OrderingTerm.asc(db.treasures.title)]);
    }
  }

  TreasureStatus _parseStatus(String raw) {
    return TreasureStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => TreasureStatus.idea,
    );
  }
}

