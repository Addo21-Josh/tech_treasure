import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../treasures/domain/entities/treasure_entity.dart';
import '../../domain/entities/content_entity.dart';

enum ExportFormat {
  shortReel,
  whatsApp,
  markdownThread,
}

/// Modal bottom sheet allowing creators to export formatted text tailored for social platforms.
class SocialMediaExportModal extends StatefulWidget {
  final TreasureEntity treasure;
  final ContentEntity? content;

  const SocialMediaExportModal({
    super.key,
    required this.treasure,
    this.content,
  });

  static Future<void> show(
    BuildContext context, {
    required TreasureEntity treasure,
    ContentEntity? content,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SocialMediaExportModal(
        treasure: treasure,
        content: content,
      ),
    );
  }

  @override
  State<SocialMediaExportModal> createState() => _SocialMediaExportModalState();
}

class _SocialMediaExportModalState extends State<SocialMediaExportModal> {
  ExportFormat _selectedFormat = ExportFormat.shortReel;

  String _generateExportText() {
    final t = widget.treasure;
    final c = widget.content;

    final hook = (c?.hook != null && c!.hook!.trim().isNotEmpty)
        ? c.hook!.trim()
        : '🔥 Don\'t scroll! Did you know this ${t.title} trick?';

    final problem = (c?.problem != null && c!.problem!.trim().isNotEmpty)
        ? c.problem!.trim()
        : t.shortDescription;

    final cta = (c?.cta != null && c!.cta!.trim().isNotEmpty)
        ? c.cta!.trim()
        : '👉 Follow for daily high-value tech secrets you actually need!';

    switch (_selectedFormat) {
      case ExportFormat.shortReel:
        final stepsText = t.steps.asMap().entries.map((entry) {
          return '${entry.key + 1}. ${entry.value}';
        }).join('\n');

        final tags = ['#tech', '#techtips', '#techhacks', '#productivity', '#shorts'];
        if (t.noAppNeeded) tags.add('#noappneeded');

        return '''$hook

$problem

📌 Quick Steps:
$stepsText

$cta

${tags.join(' ')}''';

      case ExportFormat.whatsApp:
        final stepsText = t.steps.asMap().entries.map((entry) {
          return '• *Step ${entry.key + 1}:* ${entry.value}';
        }).join('\n');

        return '''*${t.title.toUpperCase()}* 🚀

$hook

_${problem}_

*How to do it:*
$stepsText

$cta''';

      case ExportFormat.markdownThread:
        final stepsText = t.steps.asMap().entries.map((entry) {
          return '${entry.key + 1}. ${entry.value}';
        }).join('\n');

        return '''## 💡 ${t.title}

> $hook

**Context & Problem:**
$problem

**Step-by-step Tutorial:**
$stepsText

**Notes:**
${t.whyUseful ?? t.limitations ?? 'Tested & verified.'}

---
$cta''';
    }
  }

  void _copyToClipboard() {
    final text = _generateExportText();
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: AppColors.accentSuccess),
            SizedBox(width: 8),
            Text('Copied formatted post to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.darkSurfaceElevated,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = _generateExportText();

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.share_rounded, color: AppColors.accentGold),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Social Media Formatter',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Format selection chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('📱 Shorts/Reels')),
                    selected: _selectedFormat == ExportFormat.shortReel,
                    selectedColor: AppColors.accentGold.withValues(alpha: 0.2),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFormat = ExportFormat.shortReel);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('💬 WhatsApp')),
                    selected: _selectedFormat == ExportFormat.whatsApp,
                    selectedColor: AppColors.accentSuccess.withValues(alpha: 0.2),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFormat = ExportFormat.whatsApp);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('📝 Markdown')),
                    selected: _selectedFormat == ExportFormat.markdownThread,
                    selectedColor: AppColors.accentCyan.withValues(alpha: 0.2),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFormat = ExportFormat.markdownThread);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Preview box
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // Copy button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _copyToClipboard,
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy to Clipboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

