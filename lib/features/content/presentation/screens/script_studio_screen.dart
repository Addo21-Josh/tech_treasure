import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../treasures/domain/entities/treasure_entity.dart';
import '../../../treasures/presentation/providers/treasure_providers.dart';
import '../../domain/entities/content_entity.dart';
import '../../domain/entities/content_metrics_entity.dart';
import '../providers/content_providers.dart';
import '../widgets/social_media_export_modal.dart';

/// Comprehensive Script Studio for crafting high-retention tech creator scripts.
class ScriptStudioScreen extends ConsumerStatefulWidget {
  final String treasureId;

  const ScriptStudioScreen({
    super.key,
    required this.treasureId,
  });

  @override
  ConsumerState<ScriptStudioScreen> createState() => _ScriptStudioScreenState();
}

class _ScriptStudioScreenState extends ConsumerState<ScriptStudioScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _hookController;
  late TextEditingController _problemController;
  late TextEditingController _demoController;
  late TextEditingController _scriptController;
  late TextEditingController _ctaController;
  late TextEditingController _platformUrlController;

  ContentType _contentType = ContentType.youtubeShort;
  bool _isInitialized = false;
  ContentEntity? _existingContent;

  @override
  void initState() {
    super.initState();
    _hookController = TextEditingController();
    _problemController = TextEditingController();
    _demoController = TextEditingController();
    _scriptController = TextEditingController();
    _ctaController = TextEditingController();
    _platformUrlController = TextEditingController();

    _scriptController.addListener(() {
      setState(() {}); // refresh word count and estimated reading time
    });
  }

  @override
  void dispose() {
    _hookController.dispose();
    _problemController.dispose();
    _demoController.dispose();
    _scriptController.dispose();
    _ctaController.dispose();
    _platformUrlController.dispose();
    super.dispose();
  }

  void _populateControllers(ContentEntity? content, TreasureEntity treasure) {
    if (_isInitialized) return;
    _isInitialized = true;

    _existingContent = content;

    if (content != null) {
      _hookController.text = content.hook ?? '';
      _problemController.text = content.problem ?? '';
      _demoController.text = content.demonstration ?? '';
      _scriptController.text = content.script ?? '';
      _ctaController.text = content.cta ?? '';
      _platformUrlController.text = content.platformUrl ?? '';
      _contentType = content.contentType;
    } else {
      // Default initial templates
      _hookController.text = 'Stop scrolling! Here is a hidden ${treasure.title} trick that will change how you work.';
      _problemController.text = treasure.shortDescription;
      _demoController.text = treasure.steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n');
      _ctaController.text = 'Follow @TechTreasure for more daily tech discoveries! Save this before you lose it.';
      _scriptController.text = '''[HOOK - 0-3s]
${_hookController.text}

[PROBLEM - 3-10s]
Most people waste hours dealing with this. But there is a much cleaner way.

[DEMO - 10-45s]
${_demoController.text}

[OUTRO / CTA - 45-60s]
${_ctaController.text}''';
    }
  }

  int get _calculatedWordCount {
    final text = _scriptController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  int get _calculatedDurationSec {
    final words = _calculatedWordCount;
    if (words == 0) return 0;
    return ((words / 140.0) * 60).round();
  }

  String get _formattedDuration {
    final totalSec = _calculatedDurationSec;
    if (totalSec < 60) return '${totalSec}s';
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m}m ${s}s';
  }

  Future<void> _saveContent(TreasureEntity treasure) async {
    final repo = ref.read(contentRepositoryProvider);
    final now = DateTime.now();

    final toSave = ContentEntity(
      id: _existingContent?.id ?? '',
      treasureId: treasure.id,
      contentType: _contentType,
      hook: _hookController.text.trim(),
      problem: _problemController.text.trim(),
      demonstration: _demoController.text.trim(),
      script: _scriptController.text.trim(),
      cta: _ctaController.text.trim(),
      status: _existingContent?.status ?? 'scripted',
      platformUrl: _platformUrlController.text.trim().isNotEmpty ? _platformUrlController.text.trim() : null,
      publishedAt: _existingContent?.publishedAt,
      createdAt: _existingContent?.createdAt ?? now,
      updatedAt: now,
    );

    final res = await repo.saveContent(toSave);
    if (!mounted) return;

    if (res.isSuccess) {
      // Also update treasure status if it was in idea/researching
      if (treasure.status == TreasureStatus.idea ||
          treasure.status == TreasureStatus.researching ||
          treasure.status == TreasureStatus.testing ||
          treasure.status == TreasureStatus.verified ||
          treasure.status == TreasureStatus.readyToCreate) {
        await ref.read(treasureRepositoryProvider).updateStatus(treasure.id, TreasureStatus.scripted);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Script formula saved successfully!'),
          backgroundColor: AppColors.accentSuccess,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save script: ${res.failureOrNull?.message}'),
          backgroundColor: AppColors.accentDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddMetricsDialog(String contentId) {
    final viewsCtrl = TextEditingController();
    final likesCtrl = TextEditingController();
    final commentsCtrl = TextEditingController();
    final sharesCtrl = TextEditingController();
    final savesCtrl = TextEditingController();
    final followersCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.analytics_rounded, color: AppColors.accentGold),
            SizedBox(width: 8),
            Text('Log Post Performance'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: viewsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Views / Impressions'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: likesCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Likes'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: commentsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Comments'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: savesCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Bookmarks / Saves'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: sharesCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Shares'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: followersCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Followers Gained'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes (e.g. virality triggers, retention cliff)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final views = int.tryParse(viewsCtrl.text.trim()) ?? 0;
              final likes = int.tryParse(likesCtrl.text.trim()) ?? 0;
              final comments = int.tryParse(commentsCtrl.text.trim()) ?? 0;
              final shares = int.tryParse(sharesCtrl.text.trim()) ?? 0;
              final saves = int.tryParse(savesCtrl.text.trim()) ?? 0;
              final followers = int.tryParse(followersCtrl.text.trim()) ?? 0;

              final metric = ContentMetricsEntity(
                id: '',
                contentId: contentId,
                views: views,
                likes: likes,
                comments: comments,
                shares: shares,
                saves: saves,
                followersGained: followers,
                performanceNotes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                recordedAt: DateTime.now(),
              );

              await ref.read(contentRepositoryProvider).recordMetrics(metric);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Snapshot'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final treasureAsync = ref.watch(treasureDetailStreamProvider(widget.treasureId));
    final contentAsync = ref.watch(contentForTreasureProvider(widget.treasureId));

    return treasureAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Script Studio')),
        body: Center(child: Text('Error: $err')),
      ),
      data: (treasure) {
        if (treasure == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Script Studio')),
            body: const Center(child: Text('Treasure not found')),
          );
        }

        // Initialize controllers once
        contentAsync.whenData((content) {
          _populateControllers(content, treasure);
        });

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Script Studio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  treasure.title,
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.darkTextMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              // Teleprompter button
              IconButton(
                icon: const Icon(Icons.slideshow_rounded, color: AppColors.accentGold),
                tooltip: 'Launch Teleprompter',
                onPressed: () {
                  context.push('/treasures/${treasure.id}/teleprompter');
                },
              ),
              // Social Media Formatter modal
              IconButton(
                icon: const Icon(Icons.share_rounded, color: AppColors.accentCyan),
                tooltip: 'Social Formatter',
                onPressed: () {
                  SocialMediaExportModal.show(
                    context,
                    treasure: treasure,
                    content: _existingContent,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.save_rounded),
                tooltip: 'Save Script',
                onPressed: () => _saveContent(treasure),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              border: const Border(top: BorderSide(color: AppColors.darkBorder)),
            ),
            child: Row(
              children: [
                // Reading estimation badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.accentGold),
                      const SizedBox(width: 6),
                      Text(
                        '$_formattedDuration • $_calculatedWordCount words',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _saveContent(treasure),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save Script'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Platform target dropdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Target Platform', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<ContentType>(
                          initialValue: _contentType,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: ContentType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.label),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _contentType = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 1. Hook Formulator
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('🎣', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Text('The 3-Second Hook', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Grab viewer attention before they scroll. Speak directly to pain or reveal something hidden.',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.darkTextMuted),
                        ),
                        const SizedBox(height: 12),
                        // Quick Hook Templates Chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            ActionChip(
                              label: const Text('Stop scrolling...'),
                              onPressed: () {
                                _hookController.text = 'Stop scrolling! 99% of people don\'t know this ${treasure.title} secret.';
                              },
                            ),
                            ActionChip(
                              label: const Text('Secret trick...'),
                              onPressed: () {
                                _hookController.text = 'This hidden trick lets you ${treasure.title.toLowerCase()} in seconds.';
                              },
                            ),
                            ActionChip(
                              label: const Text('No app needed...'),
                              onPressed: () {
                                _hookController.text = 'You do NOT need to install any app to ${treasure.title.toLowerCase()}!';
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _hookController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'Enter your 3-second hook...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. The Problem / Context
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('⚠️', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Text('The Problem / Context', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Why standard solutions suck or what pain viewers experience every day.',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.darkTextMuted),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _problemController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'Describe the frustrating problem this solves...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. The Demonstration / Workflow
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('⚙️', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            const Text('Demonstration Steps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Spacer(),
                            TextButton.icon(
                              icon: const Icon(Icons.sync_rounded, size: 16),
                              label: const Text('Pull from Treasure'),
                              onPressed: () {
                                _demoController.text = treasure.steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'The exact on-screen visual actions viewers watch you perform.',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.darkTextMuted),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _demoController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Step-by-step visual demonstration directions...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Full Markdown Script
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('📝', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            const Text('Full Teleprompter Script', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Spacer(),
                            Text(
                              '$_calculatedWordCount words',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.accentGold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'The verbatim script read on camera or narrated as voiceover.',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.darkTextMuted),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _scriptController,
                          maxLines: 8,
                          style: const TextStyle(height: 1.5),
                          decoration: const InputDecoration(
                            hintText: 'Full teleprompter narration script...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Call To Action (CTA)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('📣', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Text('Call To Action (CTA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            ActionChip(
                              label: const Text('Follow for daily tricks'),
                              onPressed: () {
                                _ctaController.text = 'Follow @TechTreasure for more daily tech discoveries!';
                              },
                            ),
                            ActionChip(
                              label: const Text('Save for later'),
                              onPressed: () {
                                _ctaController.text = 'Save this reel right now so you don\'t forget when you need it!';
                              },
                            ),
                            ActionChip(
                              label: const Text('Share with friend'),
                              onPressed: () {
                                _ctaController.text = 'Share this with someone whose phone is always running out of storage!';
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _ctaController,
                          decoration: const InputDecoration(
                            hintText: 'Final closing line / CTA...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 6. Post-Publication Link & Performance Analytics
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.rocket_launch_rounded, color: AppColors.accentGold),
                            const SizedBox(width: 8),
                            const Text('Publication & Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Spacer(),
                            if (_existingContent != null)
                              TextButton.icon(
                                icon: const Icon(Icons.add_chart_rounded, size: 16),
                                label: const Text('Log Metrics'),
                                onPressed: () => _showAddMetricsDialog(_existingContent!.id),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _platformUrlController,
                          decoration: const InputDecoration(
                            hintText: 'https://youtube.com/shorts/... or https://tiktok.com/@...',
                            labelText: 'Live Video URL',
                            prefixIcon: Icon(Icons.link_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_existingContent != null) ...[
                          const SizedBox(height: 16),
                          Consumer(
                            builder: (context, ref, _) {
                              final metricsAsync = ref.watch(metricsForContentProvider(_existingContent!.id));
                              return metricsAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (_, _) => const SizedBox.shrink(),
                                data: (metrics) {
                                  if (metrics.isEmpty) {
                                    return Text(
                                      'No performance metrics logged yet. Tap "Log Metrics" once your video has been live for 24-48 hours.',
                                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.darkTextMuted),
                                    );
                                  }

                                  final latest = metrics.first;
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.darkSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.darkBorder),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Latest Performance Snapshot', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.accentGold)),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            _MetricPill(label: 'Views', value: '${latest.views}'),
                                            _MetricPill(label: 'Likes', value: '${latest.likes}'),
                                            _MetricPill(label: 'Saves', value: '${latest.saves}'),
                                            _MetricPill(label: 'Eng. Rate', value: '${latest.engagementRate.toStringAsFixed(1)}%'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.darkTextMuted)),
      ],
    );
  }
}

