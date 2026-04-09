import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class SkillsBottomSheet extends StatefulWidget {
  final List<String> currentSkills;

  const SkillsBottomSheet({super.key, required this.currentSkills});

  static Future<String?> show(
    BuildContext context,
    List<String> currentSkills,
  ) {
    return showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.sheetSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Theme(
        data: AppTheme.sheetTheme,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SkillsBottomSheet(currentSkills: currentSkills),
        ),
      ),
    );
  }

  @override
  State<SkillsBottomSheet> createState() => _SkillsBottomSheetState();
}

class _SkillsBottomSheetState extends State<SkillsBottomSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get _isDirty => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePop();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _handlePop,
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.sheetHandle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localization.addSkill,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    controller: _controller,
                    labelText: localization.skills,
                    hintText: localization.skillHint,

                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return localization.requiredField;
                      }
                      if (widget.currentSkills.any(
                        (s) => s.toLowerCase() == v.trim().toLowerCase(),
                      )) {
                        return localization.cvDataExists;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        localization.add,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _handlePop,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        localization.cancel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePop() {
    if (_isDirty) {
      UnsavedChangesDialog.show(
        context,
        onSave: _submit,
        onDiscard: () => Navigator.pop(context),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
