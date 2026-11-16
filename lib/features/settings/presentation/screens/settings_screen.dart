import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/backup_models.dart';
import '../providers/backup_providers.dart';

/// Settings screen for backups, restore, data portability, privacy guarantees, and app info.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;
  String? _loadingMessage;

  void _setLoading(bool loading, [String? message]) {
    setState(() {
      _isLoading = loading;
      _loadingMessage = message;
    });
  }

  Future<void> _exportJsonBackup() async {
    _setLoading(true, 'Generating cryptographic JSON backup...');
    try {
      final backupService = ref.read(backupServiceProvider);
      final result = await backupService.generateJsonBackup();

      if (!mounted) return;
      _setLoading(false);

      switch (result) {
        case Success(data: final jsonString):
          final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/tech_treasure_backup_$timestamp.json');
          await file.writeAsString(jsonString);

          await Share.shareXFiles(
            [XFile(file.path, mimeType: 'application/json')],
            subject: 'Tech Treasure JSON Backup ($timestamp)',
            text: 'Tech Treasure v1.0 offline-first encrypted database backup.',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ JSON backup ready and shared!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        case FailureResult(:final failure):
          if (mounted) {
            _showErrorDialog('Export Failed', failure.message);
          }
      }
    } catch (e) {
      if (mounted) {
        _setLoading(false);
        _showErrorDialog('Export Error', e.toString());
      }
    }
  }

  Future<void> _restoreJsonBackup() async {
    try {
      final pickResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (pickResult == null || pickResult.files.isEmpty) return;

      final pickedFile = pickResult.files.first;
      String jsonContent;

      if (pickedFile.bytes != null) {
        jsonContent = String.fromCharCodes(pickedFile.bytes!);
      } else if (pickedFile.path != null) {
        jsonContent = await File(pickedFile.path!).readAsString();
      } else {
        throw Exception('Cannot read picked file data');
      }

      _setLoading(true, 'Validating backup checksum & schema...');
      final backupService = ref.read(backupServiceProvider);
      final validationResult = await backupService.validateBackup(jsonContent);

      if (!mounted) return;
      _setLoading(false);

      switch (validationResult) {
        case FailureResult(:final failure):
          _showErrorDialog(
            'Corrupt or Invalid Backup',
            'Verification failed: ${failure.message}\n\nThe backup payload may have been tampered with or is from an incompatible schema version.',
          );
        case Success(data: final summary):
          _showRestoreConfirmationDialog(summary, jsonContent);
      }
    } catch (e) {
      if (mounted) {
        _setLoading(false);
        _showErrorDialog('File Selection Error', e.toString());
      }
    }
  }

  void _showRestoreConfirmationDialog(BackupSummary summary, String jsonContent) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.accentDanger, size: 26),
            SizedBox(width: 10),
            Text('Confirm Restore', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'A valid Tech Treasure v1.0 backup was found. Here is what will be imported:',
                style: TextStyle(fontSize: 13, color: AppColors.darkTextSecondary),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Treasures', '${summary.totalTreasures}'),
                    _buildSummaryRow('Categories', '${summary.totalCategories}'),
                    _buildSummaryRow('Sources & Links', '${summary.totalSources}'),
                    _buildSummaryRow('Empirical Tests', '${summary.totalTestRecords}'),
                    _buildSummaryRow('Content Drafts', '${summary.totalContents}'),
                    _buildSummaryRow('Metrics Records', '${summary.totalMetrics}'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentDanger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accentDanger.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.accentDanger, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'WARNING: Restoring will overwrite and replace all current local database records in an atomic transaction.',
                        style: TextStyle(fontSize: 11, color: AppColors.accentDanger, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentDanger,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.restore_rounded, size: 18),
            label: const Text('Overwrite & Restore'),
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await _executeRestore(jsonContent, summary);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _executeRestore(String jsonContent, BackupSummary summary) async {
    _setLoading(true, 'Restoring database records in atomic transaction...');
    try {
      final backupService = ref.read(backupServiceProvider);
      final restoreResult = await backupService.restoreBackup(jsonContent);

      if (!mounted) return;
      _setLoading(false);

      switch (restoreResult) {
        case Success():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Restore complete! ${summary.totalTreasures} treasures restored.'),
              backgroundColor: AppColors.accentSuccess,
              behavior: SnackBarBehavior.floating,
            ),
          );
        case FailureResult(:final failure):
          _showErrorDialog('Restoration Failed', failure.message);
      }
    } catch (e) {
      if (!mounted) return;
      _setLoading(false);
      _showErrorDialog('Restoration Error', e.toString());
    }
  }

  Future<void> _exportCsvSpreadsheet() async {
    _setLoading(true, 'Generating RFC 4180 CSV export...');
    try {
      final backupService = ref.read(backupServiceProvider);
      final result = await backupService.generateCsvExport();

      if (!mounted) return;
      _setLoading(false);

      switch (result) {
        case Success(data: final csvString):
          final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/tech_treasures_$timestamp.csv');
          await file.writeAsString(csvString);

          await Share.shareXFiles(
            [XFile(file.path, mimeType: 'text/csv')],
            subject: 'Tech Treasure CSV Export ($timestamp)',
            text: 'Tech Treasure flattened CSV export for Google Sheets or Excel.',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('📊 CSV spreadsheet export shared!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        case FailureResult(:final failure):
          if (mounted) {
            _showErrorDialog('CSV Export Failed', failure.message);
          }
      }
    } catch (e) {
      if (mounted) {
        _setLoading(false);
        _showErrorDialog('CSV Error', e.toString());
      }
    }
  }

  void _showOfflineInfo() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.offline_bolt_rounded, color: AppColors.accentSuccess, size: 24),
            SizedBox(width: 10),
            Text('Offline Guarantee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tech Treasure is engineered with strict zero-telemetry principles:',
              style: TextStyle(fontSize: 13, color: AppColors.darkTextSecondary),
            ),
            SizedBox(height: 12),
            _BulletPoint(text: '100% of data is stored in your device\'s local SQLite database.'),
            _BulletPoint(text: 'No cloud accounts, no third-party trackers, and no telemetry SDKs.'),
            _BulletPoint(text: 'Full-text search (FTS5) runs sub-millisecond on-device without remote calls.'),
            _BulletPoint(text: 'You own your data completely via standard JSON & CSV exports.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.diamond_rounded, color: AppColors.treasureGold, size: 24),
            SizedBox(width: 10),
            Text('Tech Treasure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0 (Production Release)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 8),
            Text(
              'A personal offline-first technology knowledge and content-production database for creators, researchers, and tech enthusiasts.',
              style: TextStyle(fontSize: 13, color: AppColors.darkTextSecondary),
            ),
            SizedBox(height: 12),
            Text(
              'Built with Flutter 3, Drift SQLite FTS5, and Material 3 Dark theme.',
              style: TextStyle(fontSize: 12, color: AppColors.darkTextMuted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.accentDanger, size: 24),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.darkTextSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.darkTextSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Settings & Data Portability'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // Section: Data & Backup
              _buildSectionHeader(context, 'DATA & STORAGE'),
              _buildSettingsTile(
                context,
                icon: Icons.upload_file_rounded,
                title: 'Export JSON Backup',
                subtitle: 'Complete database backup with SHA-256 integrity checksum',
                onTap: _exportJsonBackup,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.download_rounded,
                title: 'Restore JSON Backup',
                subtitle: 'Validate checksum and restore records from file',
                onTap: _restoreJsonBackup,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.table_chart_rounded,
                title: 'Export CSV Spreadsheet',
                subtitle: 'RFC 4180 flattened export for Google Sheets or Excel',
                onTap: _exportCsvSpreadsheet,
              ),
              const SizedBox(height: 24),

              // Section: Privacy & Security
              _buildSectionHeader(context, 'PRIVACY & SECURITY'),
              _buildSettingsTile(
                context,
                icon: Icons.offline_bolt_rounded,
                title: 'Offline Guarantee',
                subtitle: 'Zero cloud telemetry or external network calls',
                onTap: _showOfflineInfo,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.fingerprint_rounded,
                title: 'Biometric App Lock',
                subtitle: 'Secured via device hardware authentication (v1.1 roadmap)',
                trailing: const Text('Roadmap', style: TextStyle(fontSize: 12, color: AppColors.treasureGold)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biometric lock scheduled for v1.1 release!')),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Section: About
              _buildSectionHeader(context, 'ABOUT'),
              _buildSettingsTile(
                context,
                icon: Icons.info_outline_rounded,
                title: 'Tech Treasure Database',
                subtitle: 'Version 1.0.0 (Production Release)',
                onTap: _showAboutDialog,
              ),
            ],
          ),
        ),

        // Modal Progress Indicator
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                color: AppColors.darkCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.treasureGold),
                      const SizedBox(height: 16),
                      Text(
                        _loadingMessage ?? 'Processing...',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.treasureGold),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.darkTextSecondary)),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.darkTextMuted, size: 20),
        onTap: onTap,
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.treasureGold, fontSize: 16)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.darkTextSecondary)),
          ),
        ],
      ),
    );
  }
}
