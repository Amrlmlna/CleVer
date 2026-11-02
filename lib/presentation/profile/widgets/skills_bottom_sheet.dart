import 'package:flutter/material.dart';

import '../../../domain/entities/skill.dart';
import '../../../core/theme/clever/clever_colors.dart';
import '../../../core/theme/clever/clever_dimensions.dart';
import '../../../core/theme/clever/clever_typography.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../common/widgets/clever/clever_button.dart';
import '../../common/widgets/clever/clever_form_toggle.dart';
import '../../common/widgets/clever/clever_text_field.dart';

/// Add-skill sheet per the staging search overlay: hardskill/softskill
/// toggle (no icons), search field (surfaceRaised), and a "tambah"
/// result row. Duplicate check preserved from the legacy sheet.
class SkillsBottomSheet extends StatefulWidget {
  final List<Skill> currentSkills;

  const SkillsBottomSheet({super.key, required this.currentSkills});

  static Future<Skill?> show(BuildContext context, List<Skill> currentSkills) {
    return showModalBottomSheet<Skill>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: CleverColors.bgCanvas,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CleverRadius.sheet),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SkillsBottomSheet(currentSkills: currentSkills),
      ),
    );
  }

  @override
  State<SkillsBottomSheet> createState() => _SkillsBottomSheetState();
}

class _SkillsBottomSheetState extends State<SkillsBottomSheet> {
  final _controller = TextEditingController();
  // Staging maps the toggle to two categories: hardskill → technical,
  // softskill → soft.
  SkillCategory _selectedCategory = SkillCategory.technical;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final isDuplicate = widget.currentSkills.any(
      (s) => s.name.toLowerCase() == name.toLowerCase(),
    );
    if (isDuplicate) {
      CustomSnackBar.showWarning(
        context,
        AppLocalizations.of(context)!.cvDataExists,
      );
      return;
    }

    Navigator.pop(context, Skill(name: name, category: _selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = _controller.text.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(31, 16, 33, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CleverFormToggle(
            activeIndex: _selectedCategory == SkillCategory.soft ? 1 : 0,
            onChanged: (i) => setState(
              () => _selectedCategory = i == 1
                  ? SkillCategory.soft
                  : SkillCategory.technical,
            ),
            segments: const [
              CleverToggleSegment(label: 'hardskill'),
              CleverToggleSegment(label: 'softskill'),
            ],
          ),
          const SizedBox(height: CleverSpacing.space24),
          Text(
            l10n.addSkill,
            style: CleverTypography.h1.copyWith(
              color: CleverColors.textPrimary,
            ),
          ),
          const SizedBox(height: CleverSpacing.space24),
          CleverTextField(
            controller: _controller,
            hintText: l10n.skillHint,
            surface: CleverFieldSurface.raised,
            prefixIcon: Icons.search,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: CleverSpacing.space24),
          if (query.isNotEmpty) ...[
            Text(
              l10n.searchResult,
              style: CleverTypography.bodySm.copyWith(
                color: CleverColors.textSecondary,
              ),
            ),
            const SizedBox(height: CleverSpacing.space8),
            // The staging has no skills catalog — the single result row is
            // the create-new affordance.
            InkWell(
              onTap: _submit,
              borderRadius: BorderRadius.circular(CleverRadius.button),
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: CleverColors.surfaceSelected,
                  borderRadius: BorderRadius.circular(CleverRadius.button),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 21,
                      color: CleverColors.bgAction,
                    ),
                    const SizedBox(width: CleverSpacing.space12),
                    Expanded(
                      child: Text(
                        "'$query'",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CleverTypography.bodyStrong.copyWith(
                          color: CleverColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: CleverSpacing.space24),
          CleverButton(label: l10n.add, onTap: _submit),
        ],
      ),
    );
  }
}
