import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';

class EducationListForm extends StatefulWidget {
  final List<Education> education;
  final Function(List<Education>) onChanged;

  const EducationListForm({
    super.key,
    required this.education,
    required this.onChanged,
  });

  @override
  State<EducationListForm> createState() => _EducationListFormState();
}

class _EducationListFormState extends State<EducationListForm> {
  void _editEducation({Education? existing, int? index}) async {
    final result = await showDialog<Education>(
      context: context,
      builder: (context) => _EducationDialog(existing: existing),
    );

    if (result != null) {
      final newList = List<Education>.from(widget.education);
      if (index != null) {
        newList[index] = result;
      } else {
        newList.add(result);
      }
      widget.onChanged(newList);
    }
  }

  void _removeEducation(int index) {
    final newList = List<Education>.from(widget.education);
    newList.removeAt(index);
    widget.onChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pendidikan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton.icon(
              onPressed: () => _editEducation(),
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            ),
          ],
        ),
        if (widget.education.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Belum ada riwayat pendidikan.', style: TextStyle(color: Colors.grey)),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.education.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final edu = widget.education[index];
            return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text(edu.schoolName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${edu.degree}\n${edu.startDate} - ${edu.endDate ?? "Sekarang"}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeEducation(index),
                ),
                onTap: () => _editEducation(existing: edu, index: index),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EducationDialog extends StatefulWidget {
  final Education? existing;

  const _EducationDialog({this.existing});

  @override
  State<_EducationDialog> createState() => _EducationDialogState();
}

class _EducationDialogState extends State<_EducationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolCtrl;
  late TextEditingController _degreeCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;

  @override
  void initState() {
    super.initState();
    _schoolCtrl = TextEditingController(text: widget.existing?.schoolName);
    _degreeCtrl = TextEditingController(text: widget.existing?.degree);
    _startCtrl = TextEditingController(text: widget.existing?.startDate);
    _endCtrl = TextEditingController(text: widget.existing?.endDate);
  }

  @override
  void dispose() {
    _schoolCtrl.dispose();
    _degreeCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Tambah Pendidikan' : 'Edit Pendidikan'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _schoolCtrl,
                decoration: const InputDecoration(labelText: 'Sekolah / Universitas'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _degreeCtrl,
                decoration: const InputDecoration(labelText: 'Gelar / Jurusan'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startCtrl,
                      decoration: const InputDecoration(labelText: 'Tahun Masuk'),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _endCtrl,
                      decoration: const InputDecoration(labelText: 'Tahun Lulus (Opsional)'),
                    ),
                  ),
                ],
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
              final edu = Education(
                schoolName: _schoolCtrl.text,
                degree: _degreeCtrl.text,
                startDate: _startCtrl.text,
                endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
              );
              Navigator.pop(context, edu);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
