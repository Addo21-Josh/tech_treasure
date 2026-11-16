import '../../../../core/constants/app_enums.dart';

/// Pure domain entity representing a research citation or evidence source.
class SourceEntity {
  final String id;
  final String treasureId;
  final String title;
  final String? url;
  final SourceType sourceType;
  final String? notes;
  final DateTime createdAt;

  const SourceEntity({
    required this.id,
    required this.treasureId,
    required this.title,
    this.url,
    this.sourceType = SourceType.other,
    this.notes,
    required this.createdAt,
  });

  SourceEntity copyWith({
    String? id,
    String? treasureId,
    String? title,
    String? url,
    SourceType? sourceType,
    String? notes,
    DateTime? createdAt,
  }) {
    return SourceEntity(
      id: id ?? this.id,
      treasureId: treasureId ?? this.treasureId,
      title: title ?? this.title,
      url: url ?? this.url,
      sourceType: sourceType ?? this.sourceType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

