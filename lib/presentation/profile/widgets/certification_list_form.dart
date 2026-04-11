import 'package:flutter/material.dart';
import '../../../../domain/entities/certification.dart';
import 'certification_bottom_sheet.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../core/utils/custom_snackbar.dart';

class CertificationListForm extends StatefulWidget {
  final List<Certification> certifications;
  final Function(List<Certification>) onChanged;

  const CertificationListForm({
    super.key,
    required this.certifications,
    required this.onChanged,
  });

  @override
  State<CertificationListForm> createState() => _CertificationListFormState();
}

class _CertificationListFormState extends State<CertificationListForm> {
  void _editCertification({Certification? existing, int? index}) async {
    final result = await CertificationBottomSheet.show(
      context,
      existing: existing,
    );

    if (result != null) {
      final newList = List<Certification>.from(widget.certifications);

      if (index != null) {
        newList[index] = result;
        widget.onChanged(newList);
      } else {
        final isDuplicate = newList.any(
          (cert) =>
              cert.name.toLowerCase() == result.name.toLowerCase() &&
              cert.issuer.toLowerCase() == result.issuer.toLowerCase(),
        );

        if (isDuplicate) {
          if (mounted) {
            CustomSnackBar.showWarning(
              context,
              AppLocalizations.of(context)!.cvDataExists,
            );
          }
        } else {
          newList.add(result);
          widget.onChanged(newList);
        }
      }
    }
  }

  void _removeCertification(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDelete),
        content: Text(AppLocalizations.of(context)!.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final newList = List<Certification>.from(widget.certifications);
      newList.removeAt(index);
      widget.onChanged(newList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.certificationsLicenses,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: () => _editCertification(),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                AppLocalizations.of(context)!.add,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        if (widget.certifications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!.noCertifications,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.certifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final cert = widget.certifications[index];
            return Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).cardTheme.color,
              child: ListTile(
                title: Text(
                  cert.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  '${cert.issuer} • ${cert.date.year}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => _removeCertification(index),
                ),
                onTap: () => _editCertification(existing: cert, index: index),
              ),
            );
          },
        ),
      ],
    );
  }
}
