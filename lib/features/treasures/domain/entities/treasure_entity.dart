import 'dart:convert';
import '../../../../core/constants/app_enums.dart';

/// Pure domain entity representing a technology discovery ("Treasure").
class TreasureEntity {
  final String id;
  final String title;
  final String shortDescription;
  final String? problem;
  final String? solution;
  final String? whyUseful;
  final String categoryId;
  final String? categoryName;
  final TreasureStatus status;
  final String? device;
  final String? platform;
  final String? osVersion;
  final String? requirements;
  final List<String> steps;
  final String? limitations;
  final String? securityNotes;
  final ResearchStatus researchStatus;
  final bool isVerified;
  final bool isFavorite;
  final bool noAppNeeded;
  final int contentPotential; // 1 to 5
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  const TreasureEntity({
    required this.id,
    required this.title,
    required this.shortDescription,
    this.problem,
    this.solution,
    this.whyUseful,
    required this.categoryId,
    this.categoryName,
    this.status = TreasureStatus.idea,
    this.device,
    this.platform,
    this.osVersion,
    this.requirements,
    this.steps = const [],
    this.limitations,
    this.securityNotes,
    this.researchStatus = ResearchStatus.notResearched,
    this.isVerified = false,
    this.isFavorite = false,
    this.noAppNeeded = false,
    this.contentPotential = 3,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  /// Serializes steps list into a JSON string for database storage.
  String get stepsJson => jsonEncode(steps);

  /// Deserializes a JSON string into a list of steps.
  static List<String> parseStepsJson(String? jsonString) {
    if (jsonString == null || jsonString.trim().isEmpty) return const [];
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return const [];
  }

  TreasureEntity copyWith({
    String? id,
    String? title,
    String? shortDescription,
    String? problem,
    String? solution,
    String? whyUseful,
    String? categoryId,
    String? categoryName,
    TreasureStatus? status,
    String? device,
    String? platform,
    String? osVersion,
    String? requirements,
    List<String>? steps,
    String? limitations,
    String? securityNotes,
    ResearchStatus? researchStatus,
    bool? isVerified,
    bool? isFavorite,
    bool? noAppNeeded,
    int? contentPotential,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return TreasureEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      problem: problem ?? this.problem,
      solution: solution ?? this.solution,
      whyUseful: whyUseful ?? this.whyUseful,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      status: status ?? this.status,
      device: device ?? this.device,
      platform: platform ?? this.platform,
      osVersion: osVersion ?? this.osVersion,
      requirements: requirements ?? this.requirements,
      steps: steps ?? this.steps,
      limitations: limitations ?? this.limitations,
      securityNotes: securityNotes ?? this.securityNotes,
      researchStatus: researchStatus ?? this.researchStatus,
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
      noAppNeeded: noAppNeeded ?? this.noAppNeeded,
      contentPotential: contentPotential ?? this.contentPotential,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }
}
