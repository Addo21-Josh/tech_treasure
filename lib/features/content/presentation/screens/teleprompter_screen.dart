import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../treasures/presentation/providers/treasure_providers.dart';
import '../providers/content_providers.dart';

/// Full-screen OLED black teleprompter view with variable speed auto-scroll and mirror mode.
class TeleprompterScreen extends ConsumerStatefulWidget {
  final String treasureId;

  const TeleprompterScreen({super.key, required this.treasureId});

  @override
  ConsumerState<TeleprompterScreen> createState() => _TeleprompterScreenState();
}

class _TeleprompterScreenState extends ConsumerState<TeleprompterScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;

  bool _isPlaying = false;
  bool _isMirrored = false;
  bool _showControls = true;
  double _fontSize = 32.0;
  double _scrollSpeed = 1.0; // multiplier: 0.5x to 3.0x
  int _countdown = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _countdownTimer?.cancel();
    _scrollController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _stopScrolling();
    } else {
      _startCountdownThenScroll();
    }
  }

  void _startCountdownThenScroll() {
    setState(() {
      _countdown = 3;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        setState(() {
          _countdown = 0;
          _isPlaying = true;
        });
        _startScrolling();
      }
    });
  }

  void _startScrolling() {
    _scrollTimer?.cancel();
    // 60 fps smooth scroll timer
    const frameDuration = Duration(milliseconds: 16);
    _scrollTimer = Timer.periodic(frameDuration, (timer) {
      if (!_isPlaying || !mounted) {
        timer.cancel();
        return;
      }
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      if (currentScroll >= maxScroll) {
        _stopScrolling();
        return;
      }

      // Base speed: 1.2 pixels per 16ms tick at 1.0x (~75 px/sec)
      final step = 1.2 * _scrollSpeed;
      _scrollController.jumpTo(math.min(currentScroll + step, maxScroll));
    });
  }

  void _stopScrolling() {
    _scrollTimer?.cancel();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _resetToTop() {
    _stopScrolling();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final treasureAsync = ref.watch(
      treasureDetailStreamProvider(widget.treasureId),
    );
    final contentAsync = ref.watch(
      contentForTreasureProvider(widget.treasureId),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: treasureAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accentGold),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error loading prompter: $err',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        data: (treasure) {
          if (treasure == null) {
            return const Center(
              child: Text(
                'Treasure not found',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final content = contentAsync.value;

          // Assemble teleprompter text
          final String scriptText =
              (content?.script != null && content!.script!.trim().isNotEmpty)
              ? content.script!
              : [
                  '# ${treasure.title.toUpperCase()}\n',
                  if (content?.hook != null && content!.hook!.isNotEmpty)
                    'HOOK: ${content.hook}\n',
                  if (content?.problem != null && content!.problem!.isNotEmpty)
                    'PROBLEM: ${content.problem}\n',
                  'STEPS:',
                  ...treasure.steps.asMap().entries.map(
                    (e) => '${e.key + 1}. ${e.value}',
                  ),
                  if (content?.cta != null && content!.cta!.isNotEmpty)
                    '\nCTA: ${content.cta}',
                ].join('\n');

          return GestureDetector(
            onTap: () {
              setState(() => _showControls = !_showControls);
            },
            child: Stack(
              children: [
                // Prompter Content Area
                Positioned.fill(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: _isMirrored
                        ? Matrix4.rotationY(math.pi)
                        : Matrix4.identity(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: math.max(
                          24.0,
                          MediaQuery.of(context).size.width * 0.1,
                        ),
                        vertical: MediaQuery.of(context).size.height * 0.45,
                      ),
                      child: Text(
                        scriptText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _fontSize,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Eye-line indicator guide in middle of screen
                Center(
                  child: IgnorePointer(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.accentGold.withValues(alpha: 0.35),
                            AppColors.accentGold.withValues(alpha: 0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Countdown Overlay (3, 2, 1)
                if (_countdown > 0)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentGold,
                          width: 3,
                        ),
                      ),
                      child: Text(
                        '$_countdown',
                        style: const TextStyle(
                          color: AppColors.accentGold,
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Floating Top Bar Controls
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  top: _showControls ? 24 : -100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xCC111827),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            treasure.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isMirrored
                                ? Icons.flip_rounded
                                : Icons.flip_camera_android_rounded,
                            color: _isMirrored
                                ? AppColors.accentGold
                                : Colors.white70,
                          ),
                          tooltip: 'Mirror Mode',
                          onPressed: () {
                            setState(() => _isMirrored = !_isMirrored);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.vertical_align_top_rounded,
                            color: Colors.white70,
                          ),
                          tooltip: 'Reset to Top',
                          onPressed: _resetToTop,
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Bottom Control Bar
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  bottom: _showControls ? 24 : -160,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xEE111827),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sliders for font size & speed
                        Row(
                          children: [
                            const Icon(
                              Icons.format_size_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                            Expanded(
                              child: Slider(
                                value: _fontSize,
                                min: 20,
                                max: 56,
                                activeColor: AppColors.accentGold,
                                inactiveColor: Colors.white24,
                                onChanged: (val) =>
                                    setState(() => _fontSize = val),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.speed_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                            Expanded(
                              child: Slider(
                                value: _scrollSpeed,
                                min: 0.5,
                                max: 3.0,
                                divisions: 5,
                                label: '${_scrollSpeed}x',
                                activeColor: AppColors.accentCyan,
                                inactiveColor: Colors.white24,
                                onChanged: (val) {
                                  setState(() => _scrollSpeed = val);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Play/Pause Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: _togglePlayPause,
                              icon: Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              label: Text(
                                _isPlaying ? 'PAUSE' : 'START PROMPTER',
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: _isPlaying
                                    ? Colors.redAccent
                                    : AppColors.accentGold,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
