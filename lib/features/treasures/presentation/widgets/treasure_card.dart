import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/treasure_entity.dart';
import '../providers/treasure_providers.dart';
import 'star_rating_input.dart';
import 'status_badge.dart';

/// Card component presenting a single Treasure discovery.
class TreasureCard extends ConsumerWidget {
  final TreasureEntity treasure;

  const TreasureCard({
    super.key,
    required this.treasure,
  });

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () => context.push('/treasures/${treasure.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Category Pill, Status Badge, Favorite Toggle
              Row(
                children: [
                  if (treasure.categoryName != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        treasure.categoryName!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  StatusBadge(status: treasure.status),
                  const Spacer(),
                  IconButton(
                    iconSize: 22,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(
                      treasure.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: treasure.isFavorite ? AppColors.treasureGold : AppColors.darkTextMuted,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(treasureRepositoryProvider).toggleFavorite(treasure.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                treasure.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Short Description
              Text(
                treasure.shortDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Bottom Details Row
              Row(
                children: [
                  if (treasure.noAppNeeded) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.no_cell_rounded, size: 12, color: Color(0xFF38BDF8)),
                          SizedBox(width: 4),
                          Text(
                            'No App',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  StarRatingInput(
                    rating: treasure.contentPotential,
                    size: 14,
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(treasure.updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

