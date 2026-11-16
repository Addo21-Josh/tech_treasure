/// Core lifecycle status for a technology discovery.
enum TreasureStatus {
  idea,
  researching,
  testing,
  verified,
  readyToCreate,
  scripted,
  recorded,
  edited,
  published;

  String get label => switch (this) {
    TreasureStatus.idea => 'Idea',
    TreasureStatus.researching => 'Researching',
    TreasureStatus.testing => 'Testing',
    TreasureStatus.verified => 'Verified',
    TreasureStatus.readyToCreate => 'Ready to Create',
    TreasureStatus.scripted => 'Scripted',
    TreasureStatus.recorded => 'Recorded',
    TreasureStatus.edited => 'Edited',
    TreasureStatus.published => 'Published',
  };

  String get emoji => switch (this) {
    TreasureStatus.idea => '💡',
    TreasureStatus.researching => '🔍',
    TreasureStatus.testing => '🧪',
    TreasureStatus.verified => '✅',
    TreasureStatus.readyToCreate => '🎬',
    TreasureStatus.scripted => '📝',
    TreasureStatus.recorded => '🎥',
    TreasureStatus.edited => '✂️',
    TreasureStatus.published => '🚀',
  };
}

/// Research investigation state.
enum ResearchStatus {
  notResearched,
  researching,
  complete;

  String get label => switch (this) {
    ResearchStatus.notResearched => 'Not Researched',
    ResearchStatus.researching => 'In Progress',
    ResearchStatus.complete => 'Complete',
  };
}

/// Verification quality gate status.
enum VerificationStatus {
  unverified,
  researching,
  verified,
  failed;

  String get label => switch (this) {
    VerificationStatus.unverified => 'Unverified',
    VerificationStatus.researching => 'Researching',
    VerificationStatus.verified => 'Verified',
    VerificationStatus.failed => 'Failed',
  };
}

/// Empirical multi-device test result.
enum TestResult {
  works,
  partiallyWorks,
  doesNotWork;

  String get label => switch (this) {
    TestResult.works => 'Works',
    TestResult.partiallyWorks => 'Partially Works',
    TestResult.doesNotWork => 'Does Not Work',
  };
}

/// Target platform for content publication.
enum ContentType {
  tiktok,
  instagramReel,
  youtubeShort,
  youtubeVideo,
  facebookReel,
  blog,
  other;

  String get label => switch (this) {
    ContentType.tiktok => 'TikTok',
    ContentType.instagramReel => 'Instagram Reel',
    ContentType.youtubeShort => 'YouTube Short',
    ContentType.youtubeVideo => 'YouTube Video',
    ContentType.facebookReel => 'Facebook Reel',
    ContentType.blog => 'Blog Post',
    ContentType.other => 'Other',
  };
}

/// Citation source origin.
enum SourceType {
  officialDoc,
  youtube,
  reddit,
  blog,
  forum,
  personalDiscovery,
  other;

  String get label => switch (this) {
    SourceType.officialDoc => 'Official Documentation',
    SourceType.youtube => 'YouTube',
    SourceType.reddit => 'Reddit',
    SourceType.blog => 'Tech Blog',
    SourceType.forum => 'Developer Forum',
    SourceType.personalDiscovery => 'Personal Discovery',
    SourceType.other => 'Other',
  };
}
