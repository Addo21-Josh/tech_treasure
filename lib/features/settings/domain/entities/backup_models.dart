/// Summary of backup validation and statistics for dry-run inspection before restore.
class BackupSummary {
  final String version;
  final int schemaVersion;
  final DateTime exportedAt;
  final String appVersion;
  final int totalTreasures;
  final int totalCategories;
  final int totalTags;
  final int totalSources;
  final int totalTestRecords;
  final int totalContents;
  final int totalMetrics;
  final String checksum;
  final bool isValid;
  final String? validationError;

  const BackupSummary({
    required this.version,
    required this.schemaVersion,
    required this.exportedAt,
    required this.appVersion,
    required this.totalTreasures,
    required this.totalCategories,
    required this.totalTags,
    required this.totalSources,
    required this.totalTestRecords,
    required this.totalContents,
    required this.totalMetrics,
    required this.checksum,
    this.isValid = true,
    this.validationError,
  });

  factory BackupSummary.invalid(String error) {
    return BackupSummary(
      version: '',
      schemaVersion: 0,
      exportedAt: DateTime.now(),
      appVersion: '',
      totalTreasures: 0,
      totalCategories: 0,
      totalTags: 0,
      totalSources: 0,
      totalTestRecords: 0,
      totalContents: 0,
      totalMetrics: 0,
      checksum: '',
      isValid: false,
      validationError: error,
    );
  }
}
