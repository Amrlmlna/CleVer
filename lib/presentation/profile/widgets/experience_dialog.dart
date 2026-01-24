import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../cv/providers/cv_generation_provider.dart';

class ExperienceDialog extends ConsumerStatefulWidget {
  final Experience? existing;

  const ExperienceDialog({super.key, this.existing});

  @override
  ConsumerState<ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends ConsumerState<ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;
  late TextEditingController _descCtrl;

  bool _isRewriting = false;

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

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Format: MMM yyyy (e.g. Jan 2024)
      controller.text = DateFormat('MMM yyyy').format(picked);
    }
  }

  Future<void> _rewriteDescription() async {
    if (_descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi deskripsi dulu baru bisa di-rewrite AI!')));
      return;
    }

    setState(() {
      _isRewriting = true;
    });

    try {
      final repository = ref.read(cvRepositoryProvider);
      // We assume 'en' for professional rewrite usually, or maybe detect? 
      // Let's use 'id' if the text looks Indonesian? Or just ask user?
      // For now, let's default to 'id' since the app UI seems ID-heavy, 
      // OR utilize the creation provider language if accessible? 
      // But this dialog is used in Profile Page too, which has no creation state.
      // Safe bet: 'id'. Or 'en' if you want "More Professional".
      // Let's default to 'id' for basic usage.
      final newText = await repository.rewriteContent(_descCtrl.text, 'id');
      
      if (mounted) {
        setState(() {
          _descCtrl.text = newText;
          _isRewriting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRewriting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal rewrite: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E), // Dark Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.existing == null ? 'TAMBAH PENGALAMAN' : 'EDIT PENGALAMAN',
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.w900, 
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  controller: _titleCtrl,
                  labelText: 'Posisi / Jabatan',
                  hintText: 'Software Engineer',
                  isDark: true,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _companyCtrl,
                  labelText: 'Perusahaan',
                  hintText: 'PT Teknologi Maju',
                  isDark: true,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Dates
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _startCtrl,
                        labelText: 'Mulai',
                        hintText: 'Pilih Tanggal',
                        isDark: true,
                        readOnly: true,
                        prefixIcon: Icons.calendar_today,
                        onTap: () => _pickDate(_startCtrl),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _endCtrl,
                        labelText: 'Selesai',
                        hintText: 'Sampai Sekarang',
                        isDark: true,
                        readOnly: true,
                        prefixIcon: Icons.event,
                        onTap: () => _pickDate(_endCtrl),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Header for Description with Magic Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Deskripsi Singkat', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    TextButton.icon(
                      onPressed: _isRewriting ? null : _rewriteDescription,
                      icon: _isRewriting 
                        ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_awesome, size: 12, color: Colors.purpleAccent),
                      label: Text(_isRewriting ? 'Menulis...' : 'Rewrite AI', style: const TextStyle(color: Colors.purpleAccent, fontSize: 12)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, 
                        minimumSize: const Size(0,0), 
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                CustomTextFormField(
                  controller: _descCtrl,
                  labelText: '', // Hide label since header is above
                  hintText: 'Jelaskan tanggung jawab utama dan pencapaianmu...',
                  isDark: true,
                  maxLines: 4,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          style: TextButton.styleFrom(foregroundColor: Colors.white54),
          child: const Text('BATAL'),
        ),
        ElevatedButton(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('SIMPAN', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
