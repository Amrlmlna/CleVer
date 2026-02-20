import 'package:flutter/material.dart';
import '../../../../domain/entities/certification.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class CertificationDialog extends StatefulWidget {
  final Certification? existing;

  const CertificationDialog({super.key, this.existing});

  @override
  State<CertificationDialog> createState() => _CertificationDialogState();
}

class _CertificationDialogState extends State<CertificationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _issuerController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _issuerController = TextEditingController(text: widget.existing?.issuer ?? '');
    if (widget.existing != null) {
      _selectedDate = widget.existing!.date;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final cert = Certification(
        id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        issuer: _issuerController.text,
        date: _selectedDate,
      );
      Navigator.of(context).pop(cert);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? AppLocalizations.of(context)!.addCertification : AppLocalizations.of(context)!.editCertification),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.certificationName),
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
              ),
              TextFormField(
                controller: _issuerController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.issuer),
                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)!.dateLabel} ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(AppLocalizations.of(context)!.selectDate),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
