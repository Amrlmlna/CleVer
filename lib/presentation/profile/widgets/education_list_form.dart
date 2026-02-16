import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/university_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class EducationListForm extends StatefulWidget {
  final List<Education> education;
  final Function(List<Education>) onChanged;
  final bool isDark;

  const EducationListForm({
    super.key,
    required this.education,
    required this.onChanged,
    this.isDark = false,
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

  void _removeEducation(int index) async {
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
      final newList = List<Education>.from(widget.education);
      newList.removeAt(index);
      widget.onChanged(newList);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check both explicit flag and system theme
    final effectiveIsDark = widget.isDark || Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.educationHistory, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: effectiveIsDark ? Colors.white : Colors.black)),
            TextButton.icon(
              onPressed: () => _editEducation(),
              icon: Icon(Icons.add, color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor),
              label: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor)),
              style: TextButton.styleFrom(
                backgroundColor: effectiveIsDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
        if (widget.education.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(AppLocalizations.of(context)!.noEducation, style: TextStyle(color: effectiveIsDark ? Colors.white54 : Colors.grey)),
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
              color: effectiveIsDark ? const Color(0xFF2C2C2C) : Colors.white, // Explicit card color for contrast
              child: ListTile(
                title: Text(edu.schoolName, style: TextStyle(fontWeight: FontWeight.bold, color: effectiveIsDark ? Colors.white : Colors.black)),
                subtitle: Text('${edu.degree}\n${edu.startDate} - ${edu.endDate ?? AppLocalizations.of(context)!.present}', style: TextStyle(color: effectiveIsDark ? Colors.white70 : Colors.black87)),
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

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
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
      // Format: yyyy (Education usually mainly cares about Year)
      // Or 'MMM yyyy' for consistency. Let's stick to 'MMM yyyy' or just 'yyyy' if user prefers.
      // But let's try 'yyyy' for education as it's cleaner for schools.
      // Actually, Experience was 'MMM yyyy'. Let's do 'MMM yyyy' for consistency.
      controller.text = DateFormat('MMM yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E), // Dark Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.existing == null ? AppLocalizations.of(context)!.addEducation : AppLocalizations.of(context)!.editEducation,
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
                UniversityPicker(
                  controller: _schoolCtrl,
                  isDark: true,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _degreeCtrl,
                  labelText: AppLocalizations.of(context)!.degree,
                  hintText: AppLocalizations.of(context)!.degreeHint,
                  isDark: true,
                  validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _startCtrl,
                        labelText: AppLocalizations.of(context)!.startDate,
                        hintText: AppLocalizations.of(context)!.year,
                        isDark: true,
                        readOnly: true,
                        prefixIcon: Icons.calendar_today,
                        onTap: () => _pickDate(_startCtrl),
                        validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _endCtrl,
                        labelText: AppLocalizations.of(context)!.endDate,
                        hintText: AppLocalizations.of(context)!.year,
                        isDark: true,
                        readOnly: true,
                        prefixIcon: Icons.event,
                        onTap: () => _pickDate(_endCtrl),
                      ),
                    ),
                  ],
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
          child: Text(AppLocalizations.of(context)!.cancelAllCaps),
        ),
        ElevatedButton(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(AppLocalizations.of(context)!.saveAllCaps, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
