import '../../../../core/constants/app_enums.dart';

enum TreasureSortBy {
  recentlyUpdated,
  recentlyCreated,
  highestPotential,
  titleAsc,
}

/// Filter criteria for querying treasures.
class TreasureFilter {
  final String? categoryId;
  final TreasureStatus? status;
  final bool? isVerified;
  final bool? isFavorite;
  final bool? noAppNeeded;
  final int? minPotential;
  final String? searchQuery;
  final TreasureSortBy sortBy;

  const TreasureFilter({
    this.categoryId,
    this.status,
    this.isVerified,
    this.isFavorite,
    this.noAppNeeded,
    this.minPotential,
    this.searchQuery,
    this.sortBy = TreasureSortBy.recentlyUpdated,
  });

  bool get hasActiveFilters =>
      categoryId != null ||
      status != null ||
      isVerified != null ||
      isFavorite != null ||
      noAppNeeded != null ||
      minPotential != null ||
      (searchQuery != null && searchQuery!.trim().isNotEmpty);

  TreasureFilter copyWith({
    String? categoryId,
    TreasureStatus? status,
    bool? isVerified,
    bool? isFavorite,
    bool? noAppNeeded,
    int? minPotential,
    String? searchQuery,
    TreasureSortBy? sortBy,
    bool clearCategory = false,
    bool clearStatus = false,
  }) {
    return TreasureFilter(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      status: clearStatus ? null : (status ?? this.status),
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
      noAppNeeded: noAppNeeded ?? this.noAppNeeded,
      minPotential: minPotential ?? this.minPotential,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

