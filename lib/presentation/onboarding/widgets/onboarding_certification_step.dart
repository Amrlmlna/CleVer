import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../domain/entities/certification.dart';
import '../../profile/widgets/certification_list_form.dart';

class OnboardingCertificationStep extends StatelessWidget {
  final List<Certification> certifications;
  final ValueChanged<List<Certification>> onChanged;

  const OnboardingCertificationStep({
    super.key,
    required this.certifications,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.certificationTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.certificationSubtitle,
            style: const TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 32),
          CertificationListForm(
            certifications: certifications,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
