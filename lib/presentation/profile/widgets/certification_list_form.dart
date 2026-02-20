import 'package:flutter/material.dart';
import '../../../../domain/entities/certification.dart';
import 'certification_dialog.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class CertificationListForm extends StatefulWidget {
  final List<Certification> certifications;
  final Function(List<Certification>) onChanged;
  final bool isDark;

  const CertificationListForm({
    super.key,
    required this.certifications,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  State<CertificationListForm> createState() => _CertificationListFormState();
}

class _CertificationListFormState extends State<CertificationListForm> {
  void _editCertification({Certification? existing, int? index}) async {
    final result = await showDialog<Certification>(
      context: context,
      builder: (context) => CertificationDialog(existing: existing),
    );

    if (result != null) {
      final newList = List<Certification>.from(widget.certifications);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      widget.onChanged(newList);
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
              style: const TextStyle(color: Colors.red),
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
    final effectiveIsDark = widget.isDark || Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.certificationsLicenses, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: effectiveIsDark ? Colors.white : Colors.black)),
            TextButton.icon(
              onPressed: () => _editCertification(),
              icon: Icon(Icons.add, color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor),
              label: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor)),
              style: TextButton.styleFrom(
                backgroundColor: effectiveIsDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
        if (widget.certifications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(AppLocalizations.of(context)!.noCertifications, style: TextStyle(color: effectiveIsDark ? Colors.white54 : Colors.grey)),
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
              color: effectiveIsDark ? const Color(0xFF2C2C2C) : Colors.white,
              child: ListTile(
                title: Text(cert.name, style: TextStyle(fontWeight: FontWeight.bold, color: effectiveIsDark ? Colors.white : Colors.black)),
                subtitle: Text('${cert.issuer} • ${cert.date.year}', style: TextStyle(color: effectiveIsDark ? Colors.white70 : Colors.black87)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
