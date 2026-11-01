import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/theme/clever/clever_colors.dart';
import '../../../../core/theme/clever/clever_dimensions.dart';
import '../../../../core/theme/clever/clever_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../cv/providers/cv_generation_provider.dart';
import '../spinning_text_loader.dart';

class CleverDictateItem {
  const CleverDictateItem({
    required this.label,
    required this.captured,
    required this.onEdit,
  });

  final String label;
  final bool captured;

  /// Trailing ↗ affordance: jumps to the manual form focused on this field.
  final VoidCallback onEdit;
}

/// Clever dictate tab: capture-status checklist, the listening orb, and the
/// live transcript bar. Speech recognition feeds `/cv/parse-entity`, which
/// returns the structured fields via [onParsed].
class CleverDictatePanel extends ConsumerStatefulWidget {
  const CleverDictatePanel({
    super.key,
    required this.entityType,
    required this.items,
    required this.onParsed,
  });

  final String entityType;
  final List<CleverDictateItem> items;
  final void Function(Map<String, dynamic> data) onParsed;

  @override
  ConsumerState<CleverDictatePanel> createState() => _CleverDictatePanelState();
}

class _CleverDictatePanelState extends ConsumerState<CleverDictatePanel> {
  final SpeechToText _speech = SpeechToText();
  bool _speechAvailable = false;
  bool _listening = false;
  bool _processing = false;
  String _transcript = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onError: (error) {
          if (mounted) {
            setState(() {
              _listening = false;
              _error = error.errorMsg;
            });
          }
        },
        onStatus: (status) {
          if (status == 'notListening' && _listening && mounted) {
            _stopAndProcess();
          }
        },
      );
      if (mounted) setState(() => _speechAvailable = available);
    } catch (_) {
      if (mounted) setState(() => _speechAvailable = false);
    }
  }

  Future<void> _startListening() async {
    if (!_speechAvailable) {
      setState(
        () => _error = AppLocalizations.of(context)!.voiceSpeechUnavailable,
      );
      return;
    }
    setState(() {
      _transcript = '';
      _error = null;
      _listening = true;
    });
    await _speech.listen(
      onResult: (result) {
        if (mounted) setState(() => _transcript = result.recognizedWords);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
    );
  }

  Future<void> _stopAndProcess() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() {
      _listening = false;
      _processing = _transcript.isNotEmpty;
    });
    if (_transcript.isEmpty) return;

    try {
      final result = await ref
          .read(remoteCVDataSourceProvider)
          .parseEntity(text: _transcript, entityType: widget.entityType);
      if (mounted) widget.onParsed(result);
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context)!.voiceParseError);
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...widget.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: CleverSpacing.space12),
            child: _TipRow(item: item),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The blurred blob stays put in every state, per staging.
              const _OrbBlob(),
              const SizedBox(height: 20),
              if (_listening)
                _TranscriptRow(
                  transcript: _transcript,
                  onCancel: () async {
                    await _speech.stop();
                    if (mounted) setState(() => _listening = false);
                  },
                  onConfirm: _stopAndProcess,
                )
              else if (_processing)
                SpinningTextLoader(
                  texts: [
                    l10n.voiceProcessing,
                    l10n.voiceAnalyzing,
                    l10n.voiceAlmostDone,
                  ],
                  style: CleverTypography.bodyStrong.copyWith(
                    color: CleverColors.textPrimary,
                  ),
                  interval: const Duration(milliseconds: 800),
                )
              else
                _MicButton(onTap: _startListening),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: CleverSpacing.space12),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: CleverTypography.bodySm.copyWith(
                      color: CleverColors.textDanger,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The soft blurred blob from staging (159×159, layer blur 19.4) — no hard
/// edge; the darker weight sits at the bottom and melts upward.
class _OrbBlob extends StatelessWidget {
  const _OrbBlob();

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 19.4, sigmaY: 19.4),
      child: Container(
        width: 159,
        height: 159,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x00863516), Color(0xE6863516)],
          ),
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.item});

  final CleverDictateItem item;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.captured ? 1 : 0.65,
      child: Row(
        children: [
          SizedBox(
            width: 15,
            child: Icon(
              item.captured ? Icons.check : Icons.do_not_disturb_on,
              size: item.captured ? 15 : 12,
              color: item.captured
                  ? CleverColors.bgAction
                  : CleverColors.textPrimary,
            ),
          ),
          const SizedBox(width: CleverSpacing.space8),
          Expanded(
            child: Text(
              item.label,
              style: CleverTypography.bodyStrong.copyWith(
                color: CleverColors.textPrimary,
              ),
            ),
          ),
          InkWell(
            onTap: item.onEdit,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.north_east,
                size: 19,
                color: CleverColors.bgAction,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tap target under the blob: starts listening.
class _MicButton extends StatelessWidget {
  const _MicButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.mic_none, size: 32, color: CleverColors.bgAction),
      ),
    );
  }
}

/// Live transcript row: bare text on cream, fade-masked on both edges.
class _TranscriptRow extends StatelessWidget {
  const _TranscriptRow({
    required this.transcript,
    required this.onCancel,
    required this.onConfirm,
  });

  final String transcript;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  /// The speech result is cumulative; the ticker shows the last chunk so
  /// the freshest words stay in view, one line at a time.
  static String _latestLine(String text) {
    if (text.isEmpty) return '';
    final words = text.trim().split(RegExp(r'\s+'));
    const chunkSize = 5;
    if (words.length <= chunkSize) return text;
    return words.sublist(words.length - chunkSize).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final line = transcript.isEmpty
        ? AppLocalizations.of(context)!.voiceListening
        : _latestLine(transcript);

    return Row(
      children: [
        GestureDetector(
          onTap: onCancel,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.close, size: 20, color: CleverColors.bgAction),
          ),
        ),
        Expanded(
          child: ClipRect(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.15, 0.85, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: SizedBox(
                height: CleverTypography.bodySm.fontSize! * 1.4,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return ClipRect(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  child: Text(
                    line,
                    key: ValueKey(line),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.right,
                    style: CleverTypography.bodySm.copyWith(
                      color: CleverColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onConfirm,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.check, size: 22, color: CleverColors.bgAction),
          ),
        ),
      ],
    );
  }
}
