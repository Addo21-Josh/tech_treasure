import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/treasure_entity.dart';
import '../../domain/entities/treasure_filter.dart';
import '../../domain/repositories/treasure_repository.dart';
import '../daos/treasures_dao.dart';

/// Concrete implementation of [TreasureRepository] backed by Drift SQLite.
class TreasureRepositoryImpl implements TreasureRepository {
  final TreasuresDao _dao;
  final _uuid = const Uuid();

  TreasureRepositoryImpl(this._dao);

  @override
  Stream<List<TreasureEntity>> watchTreasures({TreasureFilter? filter}) {
    return _dao.watchTreasures(filter: filter).map((rows) {
      return rows.map(_mapToEntity).toList();
    });
  }

  @override
  Future<Result<List<TreasureEntity>, Failure>> getTreasures({TreasureFilter? filter}) async {
    try {
      final rows = await _dao.getTreasures(filter: filter);
      return Success(rows.map(_mapToEntity).toList());
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to query treasures: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<TreasureEntity, Failure>> getTreasureById(String id) async {
    try {
      final item = await _dao.getTreasureById(id);
      if (item == null) {
        return FailureResult(NotFoundFailure('Treasure with id $id not found'));
      }
      return Success(_mapToEntity(item));
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to fetch treasure: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<String, Failure>> createTreasure(TreasureEntity treasure) async {
    try {
      final now = DateTime.now();
      final id = treasure.id.isNotEmpty ? treasure.id : _uuid.v4();

      final companion = TreasuresCompanion.insert(
        id: id,
        title: treasure.title,
        shortDescription: treasure.shortDescription,
        problem: Value(treasure.problem),
        solution: Value(treasure.solution),
        whyUseful: Value(treasure.whyUseful),
        categoryId: treasure.categoryId,
        status: Value(treasure.status.name),
        device: Value(treasure.device),
        platform: Value(treasure.platform),
        osVersion: Value(treasure.osVersion),
        requirements: Value(treasure.requirements),
        stepsJson: Value(treasure.steps.isNotEmpty ? treasure.stepsJson : null),
        limitations: Value(treasure.limitations),
        securityNotes: Value(treasure.securityNotes),
        researchStatus: Value(treasure.researchStatus.name),
        isVerified: Value(treasure.isVerified),
        isFavorite: Value(treasure.isFavorite),
        noAppNeeded: Value(treasure.noAppNeeded),
        contentPotential: Value(treasure.contentPotential),
        createdAt: now,
        updatedAt: now,
      );

      await _dao.insertTreasure(companion);
      return Success(id);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to create treasure: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<void, Failure>> updateTreasure(TreasureEntity treasure) async {
    try {
      final companion = TreasuresCompanion(
        id: Value(treasure.id),
        title: Value(treasure.title),
        shortDescription: Value(treasure.shortDescription),
        problem: Value(treasure.problem),
        solution: Value(treasure.solution),
        whyUseful: Value(treasure.whyUseful),
        categoryId: Value(treasure.categoryId),
        status: Value(treasure.status.name),
        device: Value(treasure.device),
        platform: Value(treasure.platform),
        osVersion: Value(treasure.osVersion),
        requirements: Value(treasure.requirements),
        stepsJson: Value(treasure.steps.isNotEmpty ? treasure.stepsJson : null),
        limitations: Value(treasure.limitations),
        securityNotes: Value(treasure.securityNotes),
        researchStatus: Value(treasure.researchStatus.name),
        isVerified: Value(treasure.isVerified),
        isFavorite: Value(treasure.isFavorite),
        noAppNeeded: Value(treasure.noAppNeeded),
        contentPotential: Value(treasure.contentPotential),
        updatedAt: Value(DateTime.now()),
      );

      await _dao.updateTreasure(companion);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to update treasure: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<void, Failure>> deleteTreasure(String id) async {
    try {
      await _dao.deleteTreasure(id);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to delete treasure: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<bool, Failure>> toggleFavorite(String id) async {
    try {
      final newFavoriteStatus = await _dao.toggleFavorite(id);
      return Success(newFavoriteStatus);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to toggle favorite: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<void, Failure>> updateStatus(String id, TreasureStatus status) async {
    try {
      await _dao.updateStatus(id, status.name);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to update status: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<Map<TreasureStatus, int>, Failure>> getStatusCounts() async {
    try {
      final counts = await _dao.getStatusCounts();
      return Success(counts);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to get status counts: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Stream<Map<TreasureStatus, int>> watchStatusCounts() {
    return _dao.watchStatusCounts();
  }

  @override
  Future<Result<int, Failure>> getTotalCount() async {
    try {
      final total = await _dao.getTotalCount();
      return Success(total);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to fetch total count: $e', cause: e, stackTrace: st));
    }
  }

  @override
  Future<Result<List<TreasureEntity>, Failure>> searchTreasures(String queryText) async {
    try {
      final rows = await _dao.searchTreasures(queryText);
      return Success(rows.map(_mapToEntity).toList());
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to perform search: $e', cause: e, stackTrace: st));
    }
  }

  TreasureEntity _mapToEntity(TreasureWithCategory row) {
    final t = row.treasure;
    final cat = row.category;

    return TreasureEntity(
      id: t.id,
      title: t.title,
      shortDescription: t.shortDescription,
      problem: t.problem,
      solution: t.solution,
      whyUseful: t.whyUseful,
      categoryId: t.categoryId,
      categoryName: cat?.name,
      status: _parseStatus(t.status),
      device: t.device,
      platform: t.platform,
      osVersion: t.osVersion,
      requirements: t.requirements,
      steps: TreasureEntity.parseStepsJson(t.stepsJson),
      limitations: t.limitations,
      securityNotes: t.securityNotes,
      researchStatus: _parseResearchStatus(t.researchStatus),
      isVerified: t.isVerified,
      isFavorite: t.isFavorite,
      noAppNeeded: t.noAppNeeded,
      contentPotential: t.contentPotential,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
    );
  }

  TreasureStatus _parseStatus(String raw) {
    return TreasureStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => TreasureStatus.idea,
    );
  }

  ResearchStatus _parseResearchStatus(String raw) {
    return ResearchStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => ResearchStatus.notResearched,
    );
  }
}

