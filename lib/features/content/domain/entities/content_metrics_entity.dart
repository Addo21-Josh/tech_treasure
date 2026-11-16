/// Performance metrics snapshot for a published content deliverable.
class ContentMetricsEntity {
  final String id;
  final String contentId;
  final int views;
  final int likes;
  final int comments;
  final int shares;
  final int saves;
  final int followersGained;
  final String? performanceNotes;
  final DateTime recordedAt;

  const ContentMetricsEntity({
    required this.id,
    required this.contentId,
    this.views = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.saves = 0,
    this.followersGained = 0,
    this.performanceNotes,
    required this.recordedAt,
  });

  /// Total engagement count (likes + comments + shares + saves).
  int get totalEngagements => likes + comments + shares + saves;

  /// Overall engagement rate percentage.
  double get engagementRate {
    if (views <= 0) return 0.0;
    return (totalEngagements / views) * 100.0;
  }

  /// High-value save rate percentage.
  double get saveRate {
    if (views <= 0) return 0.0;
    return (saves / views) * 100.0;
  }

  ContentMetricsEntity copyWith({
    String? id,
    String? contentId,
    int? views,
    int? likes,
    int? comments,
    int? shares,
    int? saves,
    int? followersGained,
    String? performanceNotes,
    DateTime? recordedAt,
  }) {
    return ContentMetricsEntity(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      saves: saves ?? this.saves,
      followersGained: followersGained ?? this.followersGained,
      performanceNotes: performanceNotes ?? this.performanceNotes,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }
}
