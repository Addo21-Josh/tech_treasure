import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../treasures/domain/entities/treasure_filter.dart';
import '../../../treasures/presentation/providers/treasure_providers.dart';
import '../../../treasures/presentation/widgets/star_rating_input.dart';

/// Dashboard home screen displaying real-time metrics and pipeline overview.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusCountsAsync = ref.watch(statusCountsStreamProvider);
    final treasuresAsync = ref.watch(treasuresStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Treasure'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rounded, color: AppColors.treasureGold),
            tooltip: 'Starred Favorites',
            onPressed: () {
              ref.read(treasureFilterProvider.notifier).state =
                  const TreasureFilter(isFavorite: true);
              context.go('/treasures');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              'Good day 👋',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your Personal Tech Knowledge Base',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Real-Time Metrics Overview Card
            statusCountsAsync.when(
              data: (counts) {
                final total = counts.values.fold<int>(0, (prev, element) => prev + element);

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
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
                              const Icon(Icons.diamond_rounded, color: AppColors.treasureGold, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                '$total ${total == 1 ? "Treasure" : "Treasures"}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkTextPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.treasureGoldContainerDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '100% Offline',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.treasureGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Divider(color: AppColors.darkBorder),
                      const SizedBox(height: 14),

                      // Metric Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildMetricBadge(
                            '💡 ${counts[TreasureStatus.idea] ?? 0} Ideas',
                            const Color(0xFFFBBF24),
                            onTap: () {
                              ref.read(treasureFilterProvider.notifier).state =
                                  const TreasureFilter(status: TreasureStatus.idea);
                              context.go('/treasures');
                            },
                          ),
                          _buildMetricBadge(
                            '🔍 ${counts[TreasureStatus.researching] ?? 0} Researching',
                            const Color(0xFF38BDF8),
                            onTap: () {
                              ref.read(treasureFilterProvider.notifier).state =
                                  const TreasureFilter(status: TreasureStatus.researching);
                              context.go('/treasures');
                            },
                          ),
                          _buildMetricBadge(
                            '🧪 ${counts[TreasureStatus.testing] ?? 0} Testing',
                            const Color(0xFFC084FC),
                            onTap: () {
                              ref.read(treasureFilterProvider.notifier).state =
                                  const TreasureFilter(status: TreasureStatus.testing);
                              context.go('/treasures');
                            },
                          ),
                          _buildMetricBadge(
                            '✅ ${counts[TreasureStatus.verified] ?? 0} Verified',
                            const Color(0xFF4ADE80),
                            onTap: () {
                              ref.read(treasureFilterProvider.notifier).state =
                                  const TreasureFilter(status: TreasureStatus.verified);
                              context.go('/treasures');
                            },
                          ),
                          _buildMetricBadge(
                            '🎬 ${counts[TreasureStatus.readyToCreate] ?? 0} Ready',
                            const Color(0xFF818CF8),
                            onTap: () {
                              ref.read(treasureFilterProvider.notifier).state =
                                  const TreasureFilter(status: TreasureStatus.readyToCreate);
                              context.go('/treasures');
                            },
                          ),
                          _buildMetricBadge(
                            '🚀 ${counts[TreasureStatus.published] ?? 0} Published',
                            const Color(0xFF34D399),
                            onTap: () {
                              ref.read(treasureFilterProvider.notifier).state =
                                  const TreasureFilter(status: TreasureStatus.published);
                              context.go('/treasures');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),

            // Quick Actions Section
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.lightbulb_outline_rounded,
                    label: 'Ideas',
                    color: const Color(0xFFFBBF24),
                    onTap: () {
                      ref.read(treasureFilterProvider.notifier).state =
                          const TreasureFilter(status: TreasureStatus.idea);
                      context.go('/treasures');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.verified_outlined,
                    label: 'Verified',
                    color: const Color(0xFF4ADE80),
                    onTap: () {
                      ref.read(treasureFilterProvider.notifier).state =
                          const TreasureFilter(isVerified: true);
                      context.go('/treasures');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.no_cell_outlined,
                    label: 'No App',
                    color: const Color(0xFF38BDF8),
                    onTap: () {
                      ref.read(treasureFilterProvider.notifier).state =
                          const TreasureFilter(noAppNeeded: true);
                      context.go('/treasures');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Featured / Treasure of the Day Card
            treasuresAsync.when(
              data: (treasures) {
                if (treasures.isEmpty) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.treasureGold.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.treasureGold.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.diamond_outlined, color: AppColors.treasureGold, size: 36),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No Discoveries Saved Yet',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Capture your first tech tip or trick in <5 seconds. Organize, verify on devices, and script for social platforms.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => context.push('/treasures/add'),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add First Treasure'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.treasureGold,
                            foregroundColor: const Color(0xFF451A03),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Pick the highest rated or first treasure
                final featured = treasures.reduce(
                  (a, b) => a.contentPotential >= b.contentPotential ? a : b,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: Colors.deepOrangeAccent, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'TREASURE SPOTLIGHT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => context.push('/treasures/${featured.id}'),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.treasureGold.withValues(alpha: 0.4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (featured.categoryName != null)
                                  Text(
                                    featured.categoryName!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                StarRatingInput(rating: featured.contentPotential, size: 14),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              featured.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              featured.shortDescription,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.darkTextSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  'Continue Research ➔',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Creator Philosophy Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.treasureGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'The Creator Loop',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.treasureGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Capture ➔ Research ➔ Verify ➔ Test ➔ Script ➔ Publish ➔ Learn',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBadge(String label, Color color, {VoidCallback? onTap}) {
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: badge,
      );
    }

    return badge;
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
