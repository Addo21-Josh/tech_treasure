import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/treasures/domain/entities/treasure_entity.dart';
import '../../features/treasures/presentation/providers/treasure_providers.dart';
import '../services/share_intent_service.dart';
import '../theme/app_colors.dart';

/// Root shell scaffold hosting the bottom navigation bar, Quick Capture action button,
/// and Android Share Sheet intent listener.
class MainShellScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScaffold({super.key, required this.navigationShell});

  @override
  ConsumerState<MainShellScaffold> createState() => _MainShellScaffoldState();
}

class _MainShellScaffoldState extends ConsumerState<MainShellScaffold> {
  late final ShareIntentService _shareIntentService;

  @override
  void initState() {
    super.initState();
    _shareIntentService = ShareIntentService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shareIntentService.initialize(
        onTextReceived: (text) {
          if (!mounted) return;
          _openQuickCapture(
            context,
            ref,
            initialNotes: text,
            initialTitle: text.startsWith('http')
                ? 'Resource: ${Uri.tryParse(text)?.host ?? "Web Link"}'
                : null,
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _shareIntentService.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _openQuickCapture(
    BuildContext context,
    WidgetRef ref, {
    String? initialTitle,
    String? initialNotes,
  }) {
    final titleController = TextEditingController(text: initialTitle ?? '');
    final notesController = TextEditingController(text: initialNotes ?? '');
    String? selectedCategoryId;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => Consumer(
        builder: (context, modalRef, _) {
          final categoriesAsync = modalRef.watch(categoriesStreamProvider);

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          color: AppColors.treasureGold,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Quick Capture Discovery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(modalContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('input_treasure_title'),
                  controller: titleController,
                  autofocus: (initialTitle == null || initialTitle.isEmpty),
                  decoration: const InputDecoration(
                    labelText: 'Discovery Title *',
                    hintText: 'e.g. Turn Phone Into PC Mouse',
                  ),
                ),
                const SizedBox(height: 12),
                categoriesAsync.when(
                  data: (categories) {
                    selectedCategoryId ??= categories.firstOrNull?.id;
                    return DropdownButtonFormField<String>(
                      initialValue: selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: categories.map((c) {
                        return DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        );
                      }).toList(),
                      onChanged: (val) => selectedCategoryId = val,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Quick Notes or Link (Optional)',
                    hintText: 'Discovered via YouTube, requires Wi-Fi...',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(modalContext).pop();
                        context.push('/treasures/add');
                      },
                      child: const Text('Open Full Form ➔'),
                    ),
                    FilledButton.icon(
                      key: const Key('btn_quick_save'),
                      onPressed: () async {
                        final title = titleController.text.trim();
                        if (title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a title'),
                            ),
                          );
                          return;
                        }

                        final now = DateTime.now();
                        final treasure = TreasureEntity(
                          id: '',
                          title: title,
                          shortDescription:
                              notesController.text.trim().isNotEmpty
                              ? notesController.text.trim()
                              : 'Captured via Quick Capture',
                          whyUseful: notesController.text.trim().isNotEmpty
                              ? notesController.text.trim()
                              : null,
                          categoryId: selectedCategoryId ?? 'cat_other',
                          createdAt: now,
                          updatedAt: now,
                        );

                        await modalRef
                            .read(treasureRepositoryProvider)
                            .createTreasure(treasure);

                        if (context.mounted) {
                          Navigator.of(modalContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('💡 Discovery captured to Ideas!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save (<5s)'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.treasureGold,
                        foregroundColor: const Color(0xFF451A03),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      floatingActionButton: FloatingActionButton(
        key: const Key('fab_quick_capture'),
        onPressed: () => _openQuickCapture(context, ref),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.diamond_outlined),
            selectedIcon: Icon(Icons.diamond_rounded),
            label: 'Treasures',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_motion_outlined),
            selectedIcon: Icon(Icons.auto_awesome_motion_rounded),
            label: 'Pipeline',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
