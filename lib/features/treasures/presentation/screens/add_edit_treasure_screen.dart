import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/treasure_entity.dart';
import '../providers/treasure_providers.dart';
import '../widgets/star_rating_input.dart';

/// Screen for creating a new Treasure or editing an existing one.
class AddEditTreasureScreen extends ConsumerStatefulWidget {
  final String? treasureId;

  const AddEditTreasureScreen({super.key, this.treasureId});

  @override
  ConsumerState<AddEditTreasureScreen> createState() =>
      _AddEditTreasureScreenState();
}

class _AddEditTreasureScreenState extends ConsumerState<AddEditTreasureScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _shortDescController;
  late TextEditingController _problemController;
  late TextEditingController _solutionController;
  late TextEditingController _whyUsefulController;
  late TextEditingController _deviceController;
  late TextEditingController _platformController;
  late TextEditingController _osVersionController;
  late TextEditingController _requirementsController;
  late TextEditingController _limitationsController;
  late TextEditingController _securityNotesController;
  final TextEditingController _stepInputController = TextEditingController();

  String? _selectedCategoryId;
  TreasureStatus _status = TreasureStatus.idea;
  bool _noAppNeeded = false;
  int _contentPotential = 3;
  List<String> _steps = [];

  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _shortDescController = TextEditingController();
    _problemController = TextEditingController();
    _solutionController = TextEditingController();
    _whyUsefulController = TextEditingController();
    _deviceController = TextEditingController();
    _platformController = TextEditingController();
    _osVersionController = TextEditingController();
    _requirementsController = TextEditingController();
    _limitationsController = TextEditingController();
    _securityNotesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _whyUsefulController.dispose();
    _deviceController.dispose();
    _platformController.dispose();
    _osVersionController.dispose();
    _requirementsController.dispose();
    _limitationsController.dispose();
    _securityNotesController.dispose();
    _stepInputController.dispose();
    super.dispose();
  }

  void _initializeWithTreasure(TreasureEntity treasure) {
    if (_isInitialized) return;
    _isInitialized = true;
    _titleController.text = treasure.title;
    _shortDescController.text = treasure.shortDescription;
    _problemController.text = treasure.problem ?? '';
    _solutionController.text = treasure.solution ?? '';
    _whyUsefulController.text = treasure.whyUseful ?? '';
    _deviceController.text = treasure.device ?? '';
    _platformController.text = treasure.platform ?? '';
    _osVersionController.text = treasure.osVersion ?? '';
    _requirementsController.text = treasure.requirements ?? '';
    _limitationsController.text = treasure.limitations ?? '';
    _securityNotesController.text = treasure.securityNotes ?? '';
    _selectedCategoryId = treasure.categoryId;
    _status = treasure.status;
    _noAppNeeded = treasure.noAppNeeded;
    _contentPotential = treasure.contentPotential;
    _steps = List.from(treasure.steps);
  }

  void _addStep() {
    final text = _stepInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _steps.add(text);
        _stepInputController.clear();
      });
    }
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  Future<void> _saveTreasure() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() => _isSaving = true);

    final repo = ref.read(treasureRepositoryProvider);
    final now = DateTime.now();

    final treasure = TreasureEntity(
      id: widget.treasureId ?? '',
      title: _titleController.text.trim(),
      shortDescription: _shortDescController.text.trim(),
      problem: _problemController.text.trim().isNotEmpty
          ? _problemController.text.trim()
          : null,
      solution: _solutionController.text.trim().isNotEmpty
          ? _solutionController.text.trim()
          : null,
      whyUseful: _whyUsefulController.text.trim().isNotEmpty
          ? _whyUsefulController.text.trim()
          : null,
      categoryId: _selectedCategoryId!,
      status: _status,
      device: _deviceController.text.trim().isNotEmpty
          ? _deviceController.text.trim()
          : null,
      platform: _platformController.text.trim().isNotEmpty
          ? _platformController.text.trim()
          : null,
      osVersion: _osVersionController.text.trim().isNotEmpty
          ? _osVersionController.text.trim()
          : null,
      requirements: _requirementsController.text.trim().isNotEmpty
          ? _requirementsController.text.trim()
          : null,
      steps: _steps,
      limitations: _limitationsController.text.trim().isNotEmpty
          ? _limitationsController.text.trim()
          : null,
      securityNotes: _securityNotesController.text.trim().isNotEmpty
          ? _securityNotesController.text.trim()
          : null,
      noAppNeeded: _noAppNeeded,
      contentPotential: _contentPotential,
      createdAt: now,
      updatedAt: now,
    );

    if (widget.treasureId == null) {
      final result = await repo.createTreasure(treasure);
      setState(() => _isSaving = false);
      result.fold(
        onSuccess: (newId) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('💎 Treasure successfully created!')),
          );
        },
        onFailure: (f) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: ${f.message}')),
          );
        },
      );
    } else {
      final result = await repo.updateTreasure(treasure);
      setState(() => _isSaving = false);
      result.fold(
        onSuccess: (_) {
          context.pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('💎 Treasure updated!')));
        },
        onFailure: (f) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update: ${f.message}')),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    // If editing, load initial data
    if (widget.treasureId != null && !_isInitialized) {
      final treasureAsync = ref.watch(
        treasureDetailStreamProvider(widget.treasureId!),
      );
      treasureAsync.whenData((treasure) {
        if (treasure != null) {
          _initializeWithTreasure(treasure);
        }
      });
    }

    final isEdit = widget.treasureId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Treasure' : 'New Tech Treasure'),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.check_rounded,
                    color: AppColors.treasureGold,
                  ),
            tooltip: 'Save Treasure',
            onPressed: _isSaving ? null : _saveTreasure,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Treasure Title *',
                hintText: 'e.g. Turn Android Phone Into PC Mouse',
                prefixIcon: Icon(
                  Icons.title_rounded,
                  color: AppColors.treasureGold,
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),

            // Category Selector
            categoriesAsync.when(
              data: (categories) {
                // If not set yet and categories exist, default to the first one
                _selectedCategoryId ??= categories.firstOrNull?.id;

                return DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                    prefixIcon: Icon(
                      Icons.category_rounded,
                      color: AppColors.treasureGold,
                    ),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  validator: (v) =>
                      v == null ? 'Please select a category' : null,
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const Text('Error loading categories'),
            ),
            const SizedBox(height: 16),

            // Short Description
            TextFormField(
              controller: _shortDescController,
              decoration: const InputDecoration(
                labelText: 'Short Description *',
                hintText: '1-2 sentence quick summary of the trick',
                prefixIcon: Icon(
                  Icons.short_text_rounded,
                  color: AppColors.treasureGold,
                ),
              ),
              maxLines: 2,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Description is required'
                  : null,
            ),
            const SizedBox(height: 20),

            // Status & Potential Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TreasureStatus>(
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: TreasureStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text('${s.emoji} ${s.label}'),
                      );
                    }).toList(),
                    onChanged: (s) {
                      if (s != null) setState(() => _status = s);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Content Potential',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                        StarRatingInput(
                          rating: _contentPotential,
                          onRatingChanged: (r) =>
                              setState(() => _contentPotential = r),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // No App Needed Switch
            SwitchListTile(
              value: _noAppNeeded,
              onChanged: (val) => setState(() => _noAppNeeded = val),
              title: const Text('No App Needed?'),
              subtitle: const Text(
                'Built-in native device setting or trick without extra software',
              ),
              secondary: const Icon(
                Icons.no_cell_rounded,
                color: Color(0xFF38BDF8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.darkBorder),
              ),
              tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            const SizedBox(height: 24),

            // Section: Deep Knowledge (Problem & Solution)
            _buildSectionTitle('PROBLEM & SOLUTION'),
            TextFormField(
              controller: _problemController,
              decoration: const InputDecoration(
                labelText: 'Problem',
                hintText: 'What friction or inconvenience does the user have?',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _solutionController,
              decoration: const InputDecoration(
                labelText: 'Solution',
                hintText: 'What is the exact technical fix or shortcut?',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _whyUsefulController,
              decoration: const InputDecoration(
                labelText: 'Why Useful',
                hintText: 'Why does this make great educational content?',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Section: Compatibility & Requirements
            _buildSectionTitle('COMPATIBILITY & SPECS'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _deviceController,
                    decoration: const InputDecoration(
                      labelText: 'Device (e.g. Android)',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _platformController,
                    decoration: const InputDecoration(
                      labelText: 'Platform (e.g. Windows)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _osVersionController,
                    decoration: const InputDecoration(
                      labelText: 'OS Version (e.g. 14+)',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _requirementsController,
                    decoration: const InputDecoration(
                      labelText: 'Requirements (e.g. Wi-Fi)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section: Reorderable Steps
            _buildSectionTitle('STEP-BY-STEP INSTRUCTIONS'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stepInputController,
                    decoration: const InputDecoration(
                      hintText: 'Add an instruction step...',
                    ),
                    onSubmitted: (_) => _addStep(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: _addStep,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.treasureGold,
                    foregroundColor: const Color(0xFF451A03),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_steps.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No steps added yet. Add instructions in order.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkTextMuted,
                  ),
                ),
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _steps.removeAt(oldIndex);
                    _steps.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    key: ValueKey('step_$index'),
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Row(
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
                            _steps[index],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
                          onPressed: () => _removeStep(index),
                        ),
                        const Icon(
                          Icons.drag_handle_rounded,
                          color: AppColors.darkTextMuted,
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),

            // Section: Limitations & Security Notes
            _buildSectionTitle('LIMITATIONS & SECURITY NOTES'),
            TextFormField(
              controller: _limitationsController,
              decoration: const InputDecoration(
                labelText: 'Limitations',
                hintText:
                    'Known constraints, battery consumption, guest Wi-Fi blocks...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _securityNotesController,
              decoration: const InputDecoration(
                labelText: 'Security Notes',
                hintText: 'Digital safety warnings, pairing precautions...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),

            // Large Save Button
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveTreasure,
              icon: const Icon(Icons.save_rounded),
              label: Text(isEdit ? 'Update Treasure' : 'Save New Treasure'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.treasureGold,
                foregroundColor: const Color(0xFF451A03),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
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
}
