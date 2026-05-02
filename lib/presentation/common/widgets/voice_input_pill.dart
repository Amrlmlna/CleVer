import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/datasources/remote_cv_datasource.dart';
import '../../cv/providers/cv_generation_provider.dart';
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

class _VoiceInputPillState extends ConsumerState<VoiceInputPill> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isProcessing = false;
  String _lastWords = '';
  String? _error;
  String? _selectedLocaleId;
  List<LocaleName> _availableLocales = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      bool hasSpeech = await _speechToText.initialize(
        onError: (error) {
          if (mounted) {
            setState(() {
              _error = error.errorMsg;
              _isListening = false;
            });
          }
        },
        onStatus: (status) {
          if (status == 'notListening' && _isListening) {
            if (mounted) {
              setState(() {
                _isListening = false;
                if (_lastWords.isNotEmpty) {
                  _stopListeningAndProcess();
                }
              });
            }
          }
        },
      );

      if (hasSpeech && mounted) {
        final locales = await _speechToText.locales();
        final systemLocale = await _speechToText.systemLocale();
        setState(() {
          _availableLocales = locales;
          // Default to system locale if it matches our targets, otherwise app locale
          _selectedLocaleId = systemLocale?.localeId;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  void _cycleLanguage() {
    if (_availableLocales.isEmpty) return;

    setState(() {
      // Logic: System -> ID -> EN -> System
      if (_selectedLocaleId == null ||
          !_selectedLocaleId!.contains('id') &&
              !_selectedLocaleId!.contains('en')) {
        _selectedLocaleId = _availableLocales
            .firstWhere(
              (l) => l.localeId.contains('id'),
              orElse: () => _availableLocales.first,
            )
            .localeId;
      } else if (_selectedLocaleId!.contains('id')) {
        _selectedLocaleId = _availableLocales
            .firstWhere(
              (l) => l.localeId.contains('en'),
              orElse: () => _availableLocales.first,
            )
            .localeId;
      } else {
        _selectedLocaleId = null; // Back to system default
      }
    });
  }

  String _getLocaleLabel() {
    if (_selectedLocaleId == null) return 'AUTO';
    if (_selectedLocaleId!.contains('id')) return 'ID';
    if (_selectedLocaleId!.contains('en')) return 'EN';
    return _selectedLocaleId!.split('-').first.toUpperCase();
  }

  void _startListening() async {
    setState(() {
      _error = null;
      _lastWords = '';
    });

    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);

      // Use selected locale or system default
      final String? localeId = _selectedLocaleId;

      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
        },
        localeId: localeId,
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
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        // Transcription Overlay (Absolute positioned to avoid pushing UI)
        if (_isListening && _lastWords.isNotEmpty)
          Positioned(
            bottom: 60,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.sheetSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accentBlue.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                _lastWords,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.sheetOnSurface,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
                textAlign: TextAlign.right,
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0),
          ),

        // The Pill/Button
        GestureDetector(
          onTap: _isProcessing
              ? null
              : (_isListening ? _stopListeningAndProcess : _startListening),
          child: AnimatedContainer(
            duration: 300.ms,
            height: 48,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCompact && !_isListening ? 12 : 16,
            ),
            decoration: BoxDecoration(
              color: _isListening
                  ? AppColors.accentBlue.withOpacity(0.1)
                  : (_isProcessing
                        ? AppColors.grey100
                        : AppColors.sheetSurface),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: _isListening
                    ? AppColors.accentBlue
                    : (_isProcessing
                          ? AppColors.grey300
                          : AppColors.sheetDivider),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isListening)
                  const Icon(
                        Icons.mic_rounded,
                        color: AppColors.accentBlue,
                        size: 20,
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.2, 1.2),
                        duration: 600.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.2, 1.2),
                        end: const Offset(0.8, 0.8),
                      )
                else if (_isProcessing)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primaryLight,
                    ),
                  )
                else
                  const Icon(
                    Icons.mic_none_rounded,
                    color: AppColors.sheetOnSurfaceVar,
                    size: 20,
                  ),

                if (!widget.isCompact || _isListening) ...[
                  const SizedBox(width: 10),
                  Text(
                    _isListening
                        ? l10n.voiceListening
                        : (_isProcessing
                              ? l10n.voiceProcessing
                              : l10n.voiceInput),
                    style: TextStyle(
                      color: _isListening
                          ? AppColors.accentBlue
                          : AppColors.sheetOnSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: widget.isCompact ? 13 : 14,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],

                // Language Switcher Badge (Industrial Minimalist)
                if (!_isProcessing) ...[
                  SizedBox(width: widget.isCompact ? 6 : 8),
                  GestureDetector(
                    onTap: _isListening ? null : _cycleLanguage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedLocaleId == null
                            ? AppColors.grey100
                            : AppColors.accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _selectedLocaleId == null
                              ? AppColors.grey300
                              : AppColors.accentBlue.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        _getLocaleLabel(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: _selectedLocaleId == null
                              ? AppColors.grey500
                              : AppColors.accentBlue,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
