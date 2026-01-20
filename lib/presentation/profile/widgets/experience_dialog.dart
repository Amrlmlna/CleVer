import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';

class ExperienceDialog extends StatefulWidget {
  final Experience? existing;

  const ExperienceDialog({super.key, this.existing});

  @override
  State<ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.jobTitle);
    _companyCtrl = TextEditingController(text: widget.existing?.companyName);
    _startCtrl = TextEditingController(text: widget.existing?.startDate);
    _endCtrl = TextEditingController(text: widget.existing?.endDate);
    _descCtrl = TextEditingController(text: widget.existing?.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Tambah Pengalaman' : 'Edit Pengalaman'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              CustomTextFormField(
                controller: _titleCtrl,
                labelText: 'Posisi / Jabatan',
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _companyCtrl,
                labelText: 'Perusahaan',
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _startCtrl,
                      labelText: 'Mulai (Bulan/Tahun)',
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _endCtrl,
                      labelText: 'Selesai (Opsional)',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _descCtrl,
                labelText: 'Deskripsi singkat',
                maxLines: 4,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final exp = Experience(
                jobTitle: _titleCtrl.text,
                companyName: _companyCtrl.text,
                startDate: _startCtrl.text,
                endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
                description: _descCtrl.text,
              );
              Navigator.pop(context, exp);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
