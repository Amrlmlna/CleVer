import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../templates/providers/template_provider.dart';

class DeleteAccountVerificationContent extends ConsumerWidget {
  final bool keepLocalData;
  final ValueChanged<bool> onRetentionChanged;

  const DeleteAccountVerificationContent({
    super.key,
    required this.keepLocalData,
    required this.onRetentionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);
    final totalCredits = templatesAsync.maybeWhen(
      data: (templates) => templates.isNotEmpty ? templates.first.userCredits : 0,
      orElse: () => 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.creditBalance,
                style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 4),
              Text(
                "$totalCredits",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                "TOTAL CREDITS",
                style: TextStyle(color: Colors.white12, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (totalCredits > 0) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Text(
              AppLocalizations.of(context)!.creditWarning(totalCredits),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 20),
        ],
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: SwitchListTile(
            value: keepLocalData,
            onChanged: onRetentionChanged,
            title: Text(
              AppLocalizations.of(context)!.keepLocalData,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.clearLocalData,
              style: const TextStyle(color: Colors.white24, fontSize: 11),
            ),
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.white24,
          ),
        ),
      ],
    );
  }
}
