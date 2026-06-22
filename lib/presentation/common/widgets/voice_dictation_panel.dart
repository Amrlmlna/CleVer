import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../cv/providers/cv_generation_provider.dart';
import 'spinning_text_loader.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class VoiceChecklistItem {
  final String label;
  final bool isFilled;
  final VoidCallback onTap;

  const VoiceChecklistItem({
    required this.label,
    required this.isFilled,
    required this.onTap,
  });
}

class VoiceDictationPanel extends ConsumerStatefulWidget {
  final String entityType;
  final List<VoiceChecklistItem> checklistItems;
  final void Function(Map<String, dynamic> data) onParsed;
  final String instruction;

  const VoiceDictationPanel({
    super.key,
    required this.entityType,
    required this.checklistItems,
    required this.onParsed,
    required this.instruction,
  });

  @override
  ConsumerState<VoiceDictationPanel> createState() =>
      _VoiceDictationPanelState();
}

class _VoiceDictationPanelState extends ConsumerState<VoiceDictationPanel>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isProcessing = false;
  String _lastWords = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      await _speechToText.initialize(
        onError: (error) {
          if (mounted) {
            setState(() {
              _isListening = false;
              _errorMessage = error.errorMsg;
            });
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
    } catch (_) {}
  }

  void _startListening() async {
    setState(() {
      _lastWords = '';
      _errorMessage = null;
    });

    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);

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
          _errorMessage = AppLocalizations.of(context)!.voiceSpeechUnavailable;
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
    }

    if (_lastWords.isEmpty) return;

    try {
      final dataSource = ref.read(remoteCVDataSourceProvider);
      final result = await dataSource.parseEntity(
        text: _lastWords,
        entityType: widget.entityType,
      );
      if (mounted) {
        widget.onParsed(result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    // SLEEK, SYMMETRICAL MICROPHONE BUTTON
    Widget micButtonWidget = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isListening
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: Border.all(
          color: _isListening
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Center(
        child: _isProcessing
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onSurface,
                ),
              )
            : Icon(
                _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: _isListening
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                size: 24,
              ),
      ),
    );

    // PULSING SCALE ANIMATION WHEN LISTENING
    if (_isListening) {
      micButtonWidget = micButtonWidget
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.08, 1.08),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
    }

    // RESOLVE STATUS AREA WIDGETS
    Widget statusWidget;
    if (_errorMessage != null) {
      statusWidget = Text(
        _errorMessage!,
        textAlign: TextAlign.center,
        style: textTheme.bodySmall?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (_isProcessing) {
      statusWidget = SpinningTextLoader(
        texts: [
          l10n.voiceProcessing,
          l10n.voiceAnalyzing,
          l10n.voiceAlmostDone,
        ],
        style: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        interval: const Duration(milliseconds: 800),
      );
    } else if (_isListening) {
      statusWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.voiceListening,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          ...List.generate(5, (index) {
            return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scaleY(
                  begin: 0.3,
                  end: 1.5,
                  duration: Duration(milliseconds: 300 + index * 100),
                  curve: Curves.easeInOut,
                );
          }),
        ],
      );
    } else {
      statusWidget = Text(
        l10n.voiceTapMicHint,
        style: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final parts = widget.instruction.split('\n');
    final mainInstruction = parts.isNotEmpty ? parts[0] : widget.instruction;
    final exampleText = parts.length > 1 ? parts[1] : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Instructions (Premium Tip Card)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mainInstruction,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              if (exampleText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exampleText,
                    style: textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Checklist List (Compact, Minimalist, Slim)
        Column(
          children: widget.checklistItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              key: ValueKey(item.label),
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: item.isFilled
                        ? colorScheme.onSurface.withValues(alpha: 0.02)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: item.isFilled
                          ? colorScheme.outlineVariant.withValues(alpha: 0.3)
                          : colorScheme.outlineVariant.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Checklist Icon (Monochrome styling instead of generic green)
                      Icon(
                        item.isFilled
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: item.isFilled
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                        size: 18,
                      ),
                      const SizedBox(width: 12),

                      // Text
                      Expanded(
                        child: Text(
                          item.label,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // VOICE CONTROL AREA (Fixed height prevents layout shifting)
        SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _isProcessing
                    ? null
                    : (_isListening
                          ? _stopListeningAndProcess
                          : _startListening),
                child: micButtonWidget,
              ),
              const SizedBox(height: 10),
              Container(
                height: 36,
                alignment: Alignment.center,
                child: statusWidget,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
