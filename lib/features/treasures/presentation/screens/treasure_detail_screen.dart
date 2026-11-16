import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../content/presentation/widgets/social_media_export_modal.dart';
import '../../../research/domain/entities/source_entity.dart';
import '../../../research/presentation/providers/source_providers.dart';
import '../../../testing/domain/entities/test_record_entity.dart';
import '../../../testing/presentation/providers/test_providers.dart';
import '../../domain/entities/treasure_entity.dart';
import '../providers/treasure_providers.dart';
import '../widgets/star_rating_input.dart';
import '../widgets/status_badge.dart';

/// Comprehensive detail view for inspecting, advancing, verifying, and testing a Treasure.
class TreasureDetailScreen extends ConsumerStatefulWidget {
  final String treasureId;

  const TreasureDetailScreen({
    super.key,
    required this.treasureId,
  });

  @override
  ConsumerState<TreasureDetailScreen> createState() => _TreasureDetailScreenState();
}

class _TreasureDetailScreenState extends ConsumerState<TreasureDetailScreen> {
  // Verification Checklist State
  bool _sourceChecked = false;
  bool _stepsConfirmed = false;
  bool _personallyTested = false;
  bool _compatibilityChecked = false;
  bool _limitationsDocumented = false;
  bool _securityChecked = false;

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Treasure?'),
        content: const Text(
          'Are you sure you want to permanently delete this discovery? All associated test records and sources will also be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(treasureRepositoryProvider).deleteTreasure(widget.treasureId);
              if (context.mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Treasure deleted')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showStatusPicker(BuildContext context, TreasureStatus currentStatus) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Move in Content Pipeline',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...TreasureStatus.values.map((status) {
                final isSelected = status == currentStatus;
                return ListTile(
                  leading: Text(status.emoji, style: const TextStyle(fontSize: 18)),
                  title: Text(
                    status.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.treasureGold : null,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded, color: AppColors.treasureGold)
                      : null,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ref.read(treasureRepositoryProvider).updateStatus(widget.treasureId, status);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSourceDialog(BuildContext context) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final notesController = TextEditingController();
    SourceType selectedType = SourceType.officialDoc;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: const Text('Add Research Source'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Source Name *',
                      hintText: 'e.g. Microsoft Docs / YouTube',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SourceType>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(labelText: 'Source Type'),
                    items: SourceType.values.map((t) {
                      return DropdownMenuItem(value: t, child: Text(t.label));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL (Optional)',
                      hintText: 'https://...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Research Notes / Quotes',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              FilledButton(
                onPressed: () async {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    final source = SourceEntity(
                      id: '',
                      treasureId: widget.treasureId,
                      title: title,
                      sourceType: selectedType,
                      url: urlController.text.trim().isNotEmpty ? urlController.text.trim() : null,
                      notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
                      createdAt: DateTime.now(),
                    );
                    await ref.read(sourceRepositoryProvider).addSource(source);
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Save Source'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddTestDialog(BuildContext context) {
    final deviceController = TextEditingController(text: 'Samsung Galaxy');
    final osController = TextEditingController(text: 'Android 14+');
    final envController = TextEditingController(text: 'Windows 11 PC');
    final notesController = TextEditingController();
    TestResult result = TestResult.works;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: const Text('Log Device Test Record'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    key: const Key('input_test_device'),
                    controller: deviceController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Tested Device *', hintText: 'e.g. Galaxy S24'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: osController,
                    decoration: const InputDecoration(labelText: 'OS Version *', hintText: 'e.g. Android 16'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: envController,
                    decoration: const InputDecoration(labelText: 'Test Environment', hintText: 'e.g. Windows 11 Wi-Fi'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TestResult>(
                    initialValue: result,
                    decoration: const InputDecoration(labelText: 'Empirical Test Result'),
                    items: TestResult.values.map((r) {
                      return DropdownMenuItem(value: r, child: Text(r.label));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => result = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(labelText: 'Testing Notes / Observations'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              FilledButton(
                key: const Key('btn_save_test'),
                onPressed: () async {
                  final device = deviceController.text.trim();
                  final os = osController.text.trim();
                  if (device.isNotEmpty && os.isNotEmpty) {
                    final testLog = TestRecordEntity(
                      id: '',
                      treasureId: widget.treasureId,
                      device: device,
                      osVersion: os,
                      environment: envController.text.trim().isNotEmpty ? envController.text.trim() : null,
                      result: result,
                      notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
                      testedAt: DateTime.now(),
                    );
                    await ref.read(testRepositoryProvider).addTestRecord(testLog);
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Log Test'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _copySteps(List<String> steps) {
    if (steps.isEmpty) return;
    final text = steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Steps copied to clipboard!')),
    );
  }

  int get _checklistPassedCount {
    var count = 0;
    if (_sourceChecked) count++;
    if (_stepsConfirmed) count++;
    if (_personallyTested) count++;
    if (_compatibilityChecked) count++;
    if (_limitationsDocumented) count++;
    if (_securityChecked) count++;
    return count;
  }

  Future<void> _markTreasureVerified(TreasureEntity treasure) async {
    final updated = treasure.copyWith(
      isVerified: true,
      status: TreasureStatus.verified,
      updatedAt: DateTime.now(),
    );
    await ref.read(treasureRepositoryProvider).updateTreasure(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Treasure marked as Verified!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final treasureAsync = ref.watch(treasureDetailStreamProvider(widget.treasureId));
    final sourcesAsync = ref.watch(sourcesStreamProvider(widget.treasureId));
    final testsAsync = ref.watch(testsStreamProvider(widget.treasureId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treasure Detail'),
        actions: [
          treasureAsync.when(
            data: (treasure) {
              if (treasure == null) return const SizedBox.shrink();
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.movie_creation_outlined, color: AppColors.treasureGold),
                    tooltip: 'Script Studio',
                    onPressed: () => context.push('/treasures/${widget.treasureId}/studio'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: AppColors.accentCyan),
                    tooltip: 'Social Formatter',
                    onPressed: () => SocialMediaExportModal.show(context, treasure: treasure),
                  ),
                  IconButton(
                    icon: Icon(
                      treasure.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: treasure.isFavorite ? AppColors.treasureGold : null,
                    ),
                    tooltip: 'Toggle Starred',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(treasureRepositoryProvider).toggleFavorite(treasure.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: 'Edit Treasure',
                    onPressed: () => context.push('/treasures/${widget.treasureId}/edit'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    tooltip: 'Delete Treasure',
                    onPressed: () => _confirmDelete(context),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: treasureAsync.when(
        data: (treasure) {
          if (treasure == null) {
            return const Center(child: Text('Treasure not found'));
          }

          if (treasure.isVerified) {
            _sourceChecked = true;
            _stepsConfirmed = true;
            _personallyTested = true;
            _compatibilityChecked = true;
            _limitationsDocumented = true;
            _securityChecked = true;
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Category pill & Status badge
              Row(
                children: [
                  if (treasure.categoryName != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        treasure.categoryName!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  StatusBadge(
                    status: treasure.status,
                    onTap: () => _showStatusPicker(context, treasure.status),
                  ),
                  const Spacer(),
                  StarRatingInput(rating: treasure.contentPotential, size: 16),
                ],
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                treasure.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Short Description
              Text(
                treasure.shortDescription,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Quick Attributes Row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (treasure.noAppNeeded)
                    _buildAttributeBadge(
                      Icons.no_cell_rounded,
                      'No App Needed',
                      const Color(0xFF38BDF8),
                    ),
                  if (treasure.isVerified)
                    _buildAttributeBadge(
                      Icons.verified_rounded,
                      'Verified Discovery',
                      const Color(0xFF4ADE80),
                    ),
                  if (treasure.device != null)
                    _buildAttributeBadge(
                      Icons.devices_rounded,
                      treasure.device!,
                      AppColors.darkTextPrimary,
                    ),
                  if (treasure.platform != null)
                    _buildAttributeBadge(
                      Icons.laptop_rounded,
                      treasure.platform!,
                      AppColors.darkTextPrimary,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Creator Production Suite Launchpad
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.treasureGold.withValues(alpha: 0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.video_camera_front_rounded, color: AppColors.treasureGold, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Creator Production Suite',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hook formulation, full teleprompter narration, and formatted social media exports.',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.darkTextMuted),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: () => context.push('/treasures/${widget.treasureId}/studio'),
                          icon: const Icon(Icons.edit_note_rounded, size: 18),
                          label: const Text('Script Studio'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.treasureGold,
                            foregroundColor: Colors.black,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/treasures/${widget.treasureId}/teleprompter'),
                          icon: const Icon(Icons.slideshow_rounded, size: 18),
                          label: const Text('Teleprompter'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: AppColors.darkBorder),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => SocialMediaExportModal.show(context, treasure: treasure),
                          icon: const Icon(Icons.share_rounded, size: 18),
                          label: const Text('Social Post'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accentCyan,
                            side: const BorderSide(color: AppColors.accentCyan),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Problem & Solution Card
              if (treasure.problem != null || treasure.solution != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (treasure.problem != null) ...[
                        const Row(
                          children: [
                            Icon(Icons.help_outline_rounded, color: Color(0xFFFBBF24), size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Problem',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFFFBBF24),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(treasure.problem!, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 12),
                      ],
                      if (treasure.solution != null) ...[
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded, color: Color(0xFF4ADE80), size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Solution',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF4ADE80),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(treasure.solution!, style: const TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Numbered Step-by-Step Instructions
              _buildSectionHeader('STEP-BY-STEP INSTRUCTIONS'),
              if (treasure.steps.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: const Text(
                    'No instructions recorded yet. Tap Edit to add numbered steps.',
                    style: TextStyle(fontSize: 13, color: AppColors.darkTextMuted),
                  ),
                )
              else ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy Steps'),
                    onPressed: () => _copySteps(treasure.steps),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: treasure.steps.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.treasureGoldContainerDark,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.treasureGold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              treasure.steps[index],
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],

              // 6-Step Empirical Verification Checklist (PRD Section 13)
              _buildSectionHeader('VERIFICATION CHECKLIST (QUALITY GATE)'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: treasure.isVerified ? const Color(0xFF4ADE80) : AppColors.darkBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quality Progress: $_checklistPassedCount/6',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: treasure.isVerified ? const Color(0xFF4ADE80) : AppColors.treasureGold,
                          ),
                        ),
                        if (treasure.isVerified)
                          const Row(
                            children: [
                              Icon(Icons.verified_rounded, color: Color(0xFF4ADE80), size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Verified Genuine',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4ADE80),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _checklistPassedCount / 6.0,
                      backgroundColor: AppColors.darkElevated,
                      color: treasure.isVerified ? const Color(0xFF4ADE80) : AppColors.treasureGold,
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      dense: true,
                      title: const Text('Source checked & verified authoritative'),
                      value: _sourceChecked,
                      onChanged: (v) => setState(() => _sourceChecked = v ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      title: const Text('Steps confirmed working in sequence'),
                      value: _stepsConfirmed,
                      onChanged: (v) => setState(() => _stepsConfirmed = v ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      title: const Text('Personally tested on hardware'),
                      value: _personallyTested,
                      onChanged: (v) => setState(() => _personallyTested = v ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      title: const Text('Compatibility checked across versions'),
                      value: _compatibilityChecked,
                      onChanged: (v) => setState(() => _compatibilityChecked = v ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      title: const Text('Known limitations documented'),
                      value: _limitationsDocumented,
                      onChanged: (v) => setState(() => _limitationsDocumented = v ?? false),
                    ),
                    CheckboxListTile(
                      dense: true,
                      title: const Text('Security & privacy implications checked'),
                      value: _securityChecked,
                      onChanged: (v) => setState(() => _securityChecked = v ?? false),
                    ),
                    if (!treasure.isVerified) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          key: const Key('btn_mark_verified'),
                          onPressed: () => _markTreasureVerified(treasure),
                          icon: const Icon(Icons.verified_rounded, color: Color(0xFF4ADE80)),
                          label: const Text('Mark Treasure as Verified'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF4ADE80)),
                            foregroundColor: const Color(0xFF4ADE80),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Multi-Device Test Matrix Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('EMPIRICAL TEST MATRIX'),
                  IconButton(
                    key: const Key('btn_add_test_record'),
                    icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.treasureGold),
                    tooltip: 'Log Device Test',
                    onPressed: () => _showAddTestDialog(context),
                  ),
                ],
              ),
              testsAsync.when(
                data: (tests) {
                  if (tests.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.science_outlined, color: AppColors.darkTextMuted),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'No empirical tests logged yet. Test this trick on your device and record results.',
                              style: TextStyle(fontSize: 13, color: AppColors.darkTextMuted),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showAddTestDialog(context),
                            child: const Text('Log Test'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tests.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final t = tests[index];
                      final resultColor = switch (t.result) {
                        TestResult.works => const Color(0xFF4ADE80),
                        TestResult.partiallyWorks => const Color(0xFFFBBF24),
                        TestResult.doesNotWork => Colors.redAccent,
                      };

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.phone_android_rounded, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${t.device} (${t.osVersion})',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: resultColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: resultColor.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    t.result.label,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: resultColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (t.environment != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Environment: ${t.environment}',
                                style: const TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
                              ),
                            ],
                            if (t.notes != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                t.notes!,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                            const SizedBox(height: 6),
                            Text(
                              DateFormat('MMM d, yyyy').format(t.testedAt),
                              style: const TextStyle(fontSize: 11, color: AppColors.darkTextMuted),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error loading tests: $e'),
              ),
              const SizedBox(height: 24),

              // Research & Evidence Sources Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('RESEARCH SOURCES & CITATIONS'),
                  IconButton(
                    icon: const Icon(Icons.add_link_rounded, color: AppColors.treasureGold),
                    tooltip: 'Add Source',
                    onPressed: () => _showAddSourceDialog(context),
                  ),
                ],
              ),
              sourcesAsync.when(
                data: (sources) {
                  if (sources.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link_outlined, color: AppColors.darkTextMuted),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'No research sources recorded yet. Add official docs, YouTube links, or forums.',
                              style: TextStyle(fontSize: 13, color: AppColors.darkTextMuted),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showAddSourceDialog(context),
                            child: const Text('Add Source'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sources.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final s = sources[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.treasureGold.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.link_rounded, size: 16, color: AppColors.treasureGold),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        s.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.darkElevated,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          s.sourceType.label,
                                          style: const TextStyle(fontSize: 10, color: AppColors.darkTextSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (s.url != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      s.url!,
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF38BDF8)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (s.notes != null) ...[
                                    const SizedBox(height: 4),
                                    Text(s.notes!, style: const TextStyle(fontSize: 12)),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16),
                              onPressed: () => ref.read(sourceRepositoryProvider).deleteSource(s.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error loading sources: $e'),
              ),
              const SizedBox(height: 32),

              // Advance Pipeline Button
              FilledButton.icon(
                onPressed: () => _showStatusPicker(context, treasure.status),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: Text('Move Stage: ${treasure.status.label} ➔'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.treasureGold,
                  foregroundColor: const Color(0xFF451A03),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: AppColors.treasureGold,
        ),
      ),
    );
  }

  Widget _buildAttributeBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
