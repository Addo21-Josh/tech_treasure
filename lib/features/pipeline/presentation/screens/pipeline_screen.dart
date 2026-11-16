import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../treasures/domain/entities/treasure_entity.dart';
import '../../../treasures/presentation/providers/treasure_providers.dart';

/// Interactive Kanban pipeline screen organizing discoveries across creator production stages.
class PipelineScreen extends ConsumerStatefulWidget {
  const PipelineScreen({super.key});

  @override
  ConsumerState<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends ConsumerState<PipelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<TreasureStatus> _stages = [
    TreasureStatus.idea,
    TreasureStatus.researching,
    TreasureStatus.testing,
    TreasureStatus.verified,
    TreasureStatus.scripted,
    TreasureStatus.recorded,
    TreasureStatus.edited,
    TreasureStatus.published,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _stages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TreasureStatus? _getNextStage(TreasureStatus current) {
    final idx = _stages.indexOf(current);
    if (idx >= 0 && idx < _stages.length - 1) {
      return _stages[idx + 1];
    }
    return null;
  }

  Future<void> _advanceStage(TreasureEntity treasure) async {
    final next = _getNextStage(treasure.status);
    if (next != null) {
      await ref
          .read(treasureRepositoryProvider)
          .updateStatus(treasure.id, next);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved "${treasure.title}" to ${next.label}!'),
            backgroundColor: AppColors.statusColor(next),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showMoveStageSheet(TreasureEntity treasure) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.darkBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Move "${treasure.title}" to Stage:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ..._stages.map((stage) {
              final isCurrent = stage == treasure.status;
              final color = AppColors.statusColor(stage);
              return ListTile(
                leading: Text(
                  stage.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
                title: Text(
                  stage.label,
                  style: TextStyle(
                    color: isCurrent ? color : null,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isCurrent
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.accentGold,
                      )
                    : null,
                onTap: () async {
                  Navigator.pop(ctx);
                  if (!isCurrent) {
                    await ref
                        .read(treasureRepositoryProvider)
                        .updateStatus(treasure.id, stage);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusCountsAsync = ref.watch(statusCountsStreamProvider);
    final counts = statusCountsAsync.value ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Pipeline'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.accentGold,
          labelColor: AppColors.accentGold,
          unselectedLabelColor: AppColors.darkTextMuted,
          tabs: _stages.map((stage) {
            final count = counts[stage] ?? 0;
            return Tab(
              child: Row(
                children: [
                  Text(stage.emoji),
                  const SizedBox(width: 6),
                  Text(stage.label),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: count > 0
                          ? AppColors.statusColor(stage).withValues(alpha: 0.2)
                          : AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: count > 0
                            ? AppColors.statusColor(stage)
                            : AppColors.darkTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _stages.map((stage) {
          return _PipelineStageColumn(
            status: stage,
            onAdvance: _advanceStage,
            onMoveStage: _showMoveStageSheet,
          );
        }).toList(),
      ),
    );
  }
}

class _PipelineStageColumn extends ConsumerWidget {
  final TreasureStatus status;
  final Function(TreasureEntity) onAdvance;
  final Function(TreasureEntity) onMoveStage;

  const _PipelineStageColumn({
    required this.status,
    required this.onAdvance,
    required this.onMoveStage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final treasuresAsync = ref.watch(treasuresStreamProvider);

    return treasuresAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (allTreasures) {
        final stageTreasures = allTreasures
            .where((t) => t.status == status)
            .toList();

        if (stageTreasures.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(status.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  'No treasures in ${status.label}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Move cards here or create a new treasure idea.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.darkTextMuted,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: stageTreasures.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final treasure = stageTreasures[index];
            final statusColor = AppColors.statusColor(treasure.status);

            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/treasures/${treasure.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Title and Potential stars
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                treasure.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < treasure.contentPotential
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 16,
                                  color: i < treasure.contentPotential
                                      ? AppColors.accentGold
                                      : AppColors.darkTextMuted,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          treasure.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Badges Row
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${treasure.status.emoji} ${treasure.status.label}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                            if (treasure.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentSuccess.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      size: 12,
                                      color: AppColors.accentSuccess,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accentSuccess,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (treasure.noAppNeeded)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCyan.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  '⚡ No App Needed',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accentCyan,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // Action Bar on card
                        Row(
                          children: [
                            // Studio button
                            OutlinedButton.icon(
                              onPressed: () {
                                context.push(
                                  '/treasures/${treasure.id}/studio',
                                );
                              },
                              icon: const Icon(
                                Icons.movie_creation_outlined,
                                size: 16,
                              ),
                              label: const Text('Studio'),
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                foregroundColor: AppColors.accentGold,
                                side: const BorderSide(
                                  color: AppColors.accentGold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Move stage menu button
                            IconButton(
                              icon: const Icon(
                                Icons.low_priority_rounded,
                                size: 20,
                              ),
                              tooltip: 'Move to Stage...',
                              onPressed: () => onMoveStage(treasure),
                            ),
                            // Advance button
                            if (status != TreasureStatus.published)
                              FilledButton.icon(
                                onPressed: () => onAdvance(treasure),
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                ),
                                label: const Text('Next'),
                                style: FilledButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: AppColors.accentSuccess,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
