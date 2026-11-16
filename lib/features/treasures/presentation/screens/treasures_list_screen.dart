import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/treasure_filter.dart';
import '../providers/treasure_providers.dart';
import '../widgets/treasure_card.dart';

/// Screen listing all captured treasures with real-time reactive filtering and sorting.
class TreasuresListScreen extends ConsumerWidget {
  const TreasuresListScreen({super.key});

  void _showSortDialog(BuildContext context, WidgetRef ref, TreasureFilter currentFilter) {
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
                'Sort Treasures By',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.update_rounded),
                title: const Text('Recently Updated'),
                trailing: currentFilter.sortBy == TreasureSortBy.recentlyUpdated
                    ? const Icon(Icons.check_rounded, color: AppColors.treasureGold)
                    : null,
                onTap: () {
                  ref.read(treasureFilterProvider.notifier).state =
                      currentFilter.copyWith(sortBy: TreasureSortBy.recentlyUpdated);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule_rounded),
                title: const Text('Recently Created'),
                trailing: currentFilter.sortBy == TreasureSortBy.recentlyCreated
                    ? const Icon(Icons.check_rounded, color: AppColors.treasureGold)
                    : null,
                onTap: () {
                  ref.read(treasureFilterProvider.notifier).state =
                      currentFilter.copyWith(sortBy: TreasureSortBy.recentlyCreated);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_rounded, color: AppColors.treasureGold),
                title: const Text('Highest Content Potential'),
                trailing: currentFilter.sortBy == TreasureSortBy.highestPotential
                    ? const Icon(Icons.check_rounded, color: AppColors.treasureGold)
                    : null,
                onTap: () {
                  ref.read(treasureFilterProvider.notifier).state =
                      currentFilter.copyWith(sortBy: TreasureSortBy.highestPotential);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha_rounded),
                title: const Text('Title (A to Z)'),
                trailing: currentFilter.sortBy == TreasureSortBy.titleAsc
                    ? const Icon(Icons.check_rounded, color: AppColors.treasureGold)
                    : null,
                onTap: () {
                  ref.read(treasureFilterProvider.notifier).state =
                      currentFilter.copyWith(sortBy: TreasureSortBy.titleAsc);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context, WidgetRef ref, TreasureFilter filter) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Discoveries',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(treasureFilterProvider.notifier).state = const TreasureFilter();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Verified Discoveries Only'),
                    value: filter.isVerified ?? false,
                    onChanged: (val) {
                      final updated = filter.copyWith(isVerified: val == true ? true : null);
                      ref.read(treasureFilterProvider.notifier).state = updated;
                      setModalState(() {});
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('No App Needed Only'),
                    value: filter.noAppNeeded ?? false,
                    onChanged: (val) {
                      final updated = filter.copyWith(noAppNeeded: val == true ? true : null);
                      ref.read(treasureFilterProvider.notifier).state = updated;
                      setModalState(() {});
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Starred Favorites Only'),
                    value: filter.isFavorite ?? false,
                    onChanged: (val) {
                      final updated = filter.copyWith(isFavorite: val == true ? true : null);
                      ref.read(treasureFilterProvider.notifier).state = updated;
                      setModalState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Category Name *', hintText: 'e.g. AI Tools'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description (Optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final category = CategoryEntity(
                  id: '',
                  name: name,
                  description: descController.text.trim().isNotEmpty ? descController.text.trim() : null,
                  icon: 'category',
                  createdAt: DateTime.now(),
                );
                await ref.read(categoryRepositoryProvider).createCategory(category);
                if (ctx.mounted) Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filter = ref.watch(treasureFilterProvider);
    final treasuresAsync = ref.watch(treasuresStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Treasures'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: filter.hasActiveFilters ? AppColors.treasureGold : null,
            ),
            tooltip: 'Filter Treasures',
            onPressed: () => _showFilterModal(context, ref, filter),
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort Order',
            onPressed: () => _showSortDialog(context, ref, filter),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.treasureGold),
            tooltip: 'New Treasure',
            onPressed: () => context.push('/treasures/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips Bar
          categoriesAsync.when(
            data: (categories) {
              return SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 2,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isSelected = filter.categoryId == null;
                      return ChoiceChip(
                        label: const Text('All'),
                        selected: isSelected,
                        onSelected: (_) {
                          ref.read(treasureFilterProvider.notifier).state =
                              filter.copyWith(clearCategory: true);
                        },
                      );
                    }

                    if (index == categories.length + 1) {
                      return ActionChip(
                        avatar: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('New Category'),
                        onPressed: () => _showAddCategoryDialog(context, ref),
                      );
                    }

                    final cat = categories[index - 1];
                    final isSelected = filter.categoryId == cat.id;

                    return ChoiceChip(
                      label: Text(cat.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(treasureFilterProvider.notifier).state =
                            filter.copyWith(categoryId: selected ? cat.id : null, clearCategory: !selected);
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox(height: 48),
            error: (_, _) => const SizedBox.shrink(),
          ),

          // Treasures List View
          Expanded(
            child: treasuresAsync.when(
              data: (treasures) {
                if (treasures.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.treasureGold.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.diamond_outlined,
                              size: 56,
                              color: AppColors.treasureGold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            filter.hasActiveFilters ? 'No Matching Treasures' : 'No Treasures Yet',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filter.hasActiveFilters
                                ? 'Try removing some active filters to view all discoveries.'
                                : 'Start capturing useful technology discoveries, hidden shortcuts, and device tricks.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () {
                              if (filter.hasActiveFilters) {
                                ref.read(treasureFilterProvider.notifier).state = const TreasureFilter();
                              } else {
                                context.push('/treasures/add');
                              }
                            },
                            icon: Icon(filter.hasActiveFilters ? Icons.clear_rounded : Icons.add_rounded),
                            label: Text(filter.hasActiveFilters ? 'Reset Filters' : 'Add Your First Treasure'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.treasureGold,
                              foregroundColor: const Color(0xFF451A03),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: treasures.length,
                  itemBuilder: (context, index) {
                    final item = treasures[index];
                    return TreasureCard(treasure: item);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
