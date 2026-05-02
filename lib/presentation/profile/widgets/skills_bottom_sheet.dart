import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/unsaved_changes_dialog.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/skill.dart';
import '../../common/widgets/sheet/sheet_header.dart';
import '../../common/widgets/sheet/sheet_action_buttons.dart';

class SkillsBottomSheet extends StatefulWidget {
  final List<Skill> currentSkills;

  const SkillsBottomSheet({super.key, required this.currentSkills});

  static Future<Skill?> show(BuildContext context, List<Skill> currentSkills) {
    return showModalBottomSheet<Skill>(
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
  SkillCategory _selectedCategory = SkillCategory.technical;
  bool _canPopNow = false;

  bool get _isDirty => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _canPopNow = true);
      Navigator.pop(
        context,
        Skill(name: _controller.text.trim(), category: _selectedCategory),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isId = Localizations.localeOf(context).languageCode == 'id';

    return PopScope(
      canPop: _canPopNow,
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
                  SheetHeader(
                    title: localization.addSkill,
                    onClosing: _handlePop,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    isId ? 'Kategori' : 'Category',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: SkillCategory.values.map((category) {
                      final isSelected = _selectedCategory == category;
                      return ChoiceChip(
                        label: Text(
                          isId ? category.displayNameId : category.displayName,
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedCategory = category);
                        },
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  CustomTextFormField(
                    controller: _controller,
                    labelText: localization.skills,
                    hintText: localization.skillHint,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return localization.requiredField;
                      }
                      if (widget.currentSkills.any(
                        (s) => s.name.toLowerCase() == v.trim().toLowerCase(),
                      )) {
                        return localization.cvDataExists;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SheetActionButtons(
                    onSave: _submit,
                    onCancel: _handlePop,
                    saveLabel: localization.add,
                    voiceEntityType: 'skill',
                    onVoiceParsed: (data) {
                      setState(() {
                        if (data['name'] != null &&
                            data['name'].toString().isNotEmpty) {
                          _controller.text = data['name'];
                        }
                        if (data['category'] != null &&
                            data['category'].toString().isNotEmpty) {
                          final categoryStr = data['category']
                              .toString()
                              .toLowerCase();
                          try {
                            _selectedCategory = SkillCategory.values.firstWhere(
                              (c) => c.name.toLowerCase() == categoryStr,
                            );
                          } catch (_) {
                            // Fallback to existing or default
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePop() async {
    if (_canPopNow) return;

    if (!_isDirty) {
      setState(() => _canPopNow = true);
      Navigator.pop(context);
      return;
    }

    Skill? savedSkill;
    final result = await UnsavedChangesDialog.show(
      context,
      onSave: () async {
        if (_formKey.currentState!.validate()) {
          savedSkill = Skill(
            name: _controller.text.trim(),
            category: _selectedCategory,
          );
        }
      },
      onDiscard: () async {},
    );

    if (result == true && mounted) {
      setState(() => _canPopNow = true);
      Navigator.pop(context, savedSkill);
    }
  }
}
