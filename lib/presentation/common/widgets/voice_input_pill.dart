import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/datasources/remote_cv_datasource.dart';
import '../../cv/providers/cv_generation_provider.dart';
import 'spinning_text_loader.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

typedef OnEntityParsed = void Function(Map<String, dynamic> data);

class VoiceInputPill extends ConsumerStatefulWidget {
  final String entityType;
  final OnEntityParsed onParsed;
  final bool isCompact;

  const VoiceInputPill({
    super.key,
    required this.entityType,
    required this.onParsed,
    this.isCompact = false,
  });

  @override
  ConsumerState<VoiceInputPill> createState() => _VoiceInputPillState();
}

class _VoiceInputPillState extends ConsumerState<VoiceInputPill>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isProcessing = false;
  String _lastWords = '';
  String? _error;

  late AnimationController _animationController;
  late Animation<double> _expansionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _expansionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    );
    _initSpeech();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    try {
      await _speechToText.initialize(
        onError: (error) {
          if (mounted) {
            setState(() {
              _error = error.errorMsg;
              _isListening = false;
            });
            _animationController.reverse();
          }
        },
        onStatus: (status) {
          if (status == 'notListening' && _isListening) {
            if (mounted) {
              _stopListeningAndProcess();
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  void _startListening() async {
    setState(() {
      _error = null;
      _lastWords = '';
    });

    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _animationController.forward();

      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
        },
        localeId: null,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
      );
    } else {
      if (mounted) {
        setState(() {
          _error = "Speech recognition not available";
        });
      }
    }
  }

  void _stopListeningAndProcess() async {
    await _speechToText.stop();

    if (mounted) {
      setState(() {
        _isListening = false;
        if (_lastWords.isNotEmpty) {
          _isProcessing = true;
        }
      });
      if (_lastWords.isEmpty) {
        _animationController.reverse();
      }
    }

    if (_lastWords.isEmpty) return;

    try {
      final dataSource = ref.read(remoteCVDataSourceProvider);
      final result = await dataSource.parseEntity(
        text: _lastWords,
        entityType: widget.entityType,
      );
      widget.onParsed(result);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _expansionAnimation,
          builder: (context, child) {
            final double expandedWidth = constraints.maxWidth;
            final double currentWidth = lerpDouble(
              widget.isCompact ? 130.0 : 160.0,
              expandedWidth,
              _expansionAnimation.value,
            )!;

            final colorScheme = Theme.of(context).colorScheme;
            final isExpanded = _expansionAnimation.value > 0.5;

            return GestureDetector(
              onTap: _isProcessing
                  ? null
                  : (_isListening ? _stopListeningAndProcess : _startListening),
              child: Container(
                width: currentWidth,
                height: 48,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    colorScheme.surface,
                    colorScheme.inverseSurface,
                    _expansionAnimation.value,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Color.lerp(
                      colorScheme.outlineVariant,
                      colorScheme.onSurface.withValues(alpha: 0.1),
                      _expansionAnimation.value,
                    )!,
                    width: 1.5,
                  ),
                  boxShadow: _isListening
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_expansionAnimation.value > 0.5)
                      _isProcessing
                          ? SpinningTextLoader(
                              texts: [
                                l10n.voiceProcessing,
                                l10n.voiceAnalyzing,
                                l10n.voiceAlmostDone,
                              ],
                              style: TextStyle(
                                color: colorScheme.onInverseSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black,
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.35, 0.65, 1.0],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 45,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Text(
                                    _lastWords.isEmpty
                                        ? l10n.voiceListening
                                        : _lastWords,
                                    style: TextStyle(
                                      color: colorScheme.onInverseSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                              ),
                            )
                    else
                      Opacity(
                        opacity:
                            1.0 -
                            (_expansionAnimation.value * 2).clamp(0.0, 1.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.mic_none_rounded,
                              color: colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                l10n.voiceUseSuara,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Positioned(
                      right: lerpDouble(
                        (currentWidth / 2) - (widget.isCompact ? 40 : 60),
                        12,
                        _expansionAnimation.value,
                      ),
                      child:
                          Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isListening
                                      ? colorScheme.onInverseSurface
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: _isProcessing
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : (_isListening
                                            ? null
                                            : const SizedBox.shrink()),
                                ),
                              )
                              .animate(target: _isListening ? 1 : 0)
                              .scale(
                                begin: const Offset(0.0, 0.0),
                                end: const Offset(1.0, 1.0),
                                duration: 300.ms,
                                curve: Curves.easeOutBack,
                              ),
                    ),

                    if (_isListening)
                      Positioned(
                        right: 12,
                        child:
                            Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.onInverseSurface,
                                      width: 2,
                                    ),
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .scale(
                                  begin: const Offset(1.0, 1.0),
                                  end: const Offset(2.0, 2.0),
                                  duration: 1.seconds,
                                )
                                .fadeOut(),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
