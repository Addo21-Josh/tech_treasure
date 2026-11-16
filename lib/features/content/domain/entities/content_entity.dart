import '../../../../core/constants/app_enums.dart';

/// Content deliverable entity representing the script and production formula for a treasure.
class ContentEntity {
  final String id;
  final String treasureId;
  final ContentType contentType;
  final String? hook;
  final String? problem;
  final String? demonstration;
  final String? script;
  final String? cta;
  final String status;
  final String? platformUrl;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContentEntity({
    required this.id,
    required this.treasureId,
    required this.contentType,
    this.hook,
    this.problem,
    this.demonstration,
    this.script,
    this.cta,
    this.status = 'idea',
    this.platformUrl,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to initialize a fresh empty script formula for a treasure.
  factory ContentEntity.fresh({
    required String id,
    required String treasureId,
    ContentType contentType = ContentType.youtubeShort,
    String? defaultDemonstration,
  }) {
    final now = DateTime.now();
    return ContentEntity(
      id: id,
      treasureId: treasureId,
      contentType: contentType,
      hook: '',
      problem: '',
      demonstration: defaultDemonstration ?? '',
      script: '',
      cta: 'Follow @TechTreasure for daily tech secrets you actually need!',
      status: 'idea',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Calculates total word count across script (or composite components).
  int get wordCount {
    final fullText = (script != null && script!.trim().isNotEmpty)
        ? script!
        : '${hook ?? ''} ${problem ?? ''} ${demonstration ?? ''} ${cta ?? ''}';
    final words = fullText.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    return words.length;
  }

  /// Estimated speaking time in seconds at a natural 140 words-per-minute pace.
  int get estimatedSeconds {
    final words = wordCount;
    if (words == 0) return 0;
    return ((words / 140.0) * 60).round();
  }

  /// Human-friendly duration string (e.g., "45s", "1m 15s").
  String get formattedEstimatedDuration {
    final totalSec = estimatedSeconds;
    if (totalSec < 60) {
      return '${totalSec}s';
    }
    final minutes = totalSec ~/ 60;
    final remainingSec = totalSec % 60;
    return '${minutes}m ${remainingSec}s';
  }

  bool get isPublished => publishedAt != null;

  ContentEntity copyWith({
    String? id,
    String? treasureId,
    ContentType? contentType,
    String? hook,
    String? problem,
    String? demonstration,
    String? script,
    String? cta,
    String? status,
    String? platformUrl,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContentEntity(
      id: id ?? this.id,
      treasureId: treasureId ?? this.treasureId,
      contentType: contentType ?? this.contentType,
      hook: hook ?? this.hook,
      problem: problem ?? this.problem,
      demonstration: demonstration ?? this.demonstration,
      script: script ?? this.script,
      cta: cta ?? this.cta,
      status: status ?? this.status,
      platformUrl: platformUrl ?? this.platformUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

