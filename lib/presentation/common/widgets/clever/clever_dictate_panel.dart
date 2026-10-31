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
    if (_listening) {
      return _TranscriptBar(
        transcript: _transcript,
        onCancel: () async {
          await _speech.stop();
          if (mounted) setState(() => _listening = false);
        },
        onConfirm: _stopAndProcess,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...widget.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: CleverSpacing.space12),
            child: _TipRow(item: item),
          ),
        ),
        const SizedBox(height: CleverSpacing.space16),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: CleverSpacing.space12),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: CleverTypography.bodySm.copyWith(
                color: CleverColors.textDanger,
              ),
            ),
          ),
        if (_processing)
          SizedBox(
            height: 159,
            child: Center(
              child: SpinningTextLoader(
                texts: [
                  AppLocalizations.of(context)!.voiceProcessing,
                  AppLocalizations.of(context)!.voiceAnalyzing,
                  AppLocalizations.of(context)!.voiceAlmostDone,
                ],
                style: CleverTypography.bodyStrong.copyWith(
                  color: CleverColors.textPrimary,
                ),
                interval: const Duration(milliseconds: 800),
              ),
            ),
          )
        else
          _DictateOrb(onTap: _startListening),
      ],
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
          Icon(
            item.captured ? Icons.check_circle : Icons.do_not_disturb_on,
            size: 15,
            color: item.captured
                ? CleverColors.bgAction
                : CleverColors.textPrimary,
          ),
          const SizedBox(width: CleverSpacing.space12),
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
            child: Padding(
              padding: const EdgeInsets.all(4),
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

class _DictateOrb extends StatelessWidget {
  const _DictateOrb({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 159,
              height: 159,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0x99863516), const Color(0x00863516)],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.mic_none,
                  size: 40,
                  color: CleverColors.bgAction,
                ),
              ),
            ),
          ),
          const SizedBox(height: CleverSpacing.space12),
          Text(
            l10n.voiceTapMicHint,
            style: CleverTypography.bodySm.copyWith(
              color: CleverColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Live listening state: cancel X, the growing transcript pill, confirm ✓.
class _TranscriptBar extends StatelessWidget {
  const _TranscriptBar({
    required this.transcript,
    required this.onCancel,
    required this.onConfirm,
  });

  final String transcript;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 159,
      alignment: Alignment.center,
      child: Row(
        children: [
          _RoundAction(icon: Icons.close, onTap: onCancel),
          const SizedBox(width: CleverSpacing.space12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: CleverSpacing.space16,
                vertical: CleverSpacing.space12,
              ),
              constraints: const BoxConstraints(minHeight: 55),
              decoration: BoxDecoration(
                color: CleverColors.surfaceSelected,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                transcript.isEmpty
                    ? AppLocalizations.of(context)!.voiceListening
                    : transcript,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: CleverTypography.bodySm.copyWith(
                  color: CleverColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: CleverSpacing.space12),
          _RoundAction(icon: Icons.check, onTap: onConfirm),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, size: 22, color: CleverColors.bgAction),
      ),
    );
  }
}
