import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../domain/entities/tailor_analysis.dart';
import '../../../common/widgets/spinning_text_loader.dart';

class RequirementChecklist extends StatefulWidget {
  final TailorAnalysis analysis;

  const RequirementChecklist({super.key, required this.analysis});

  @override
  State<RequirementChecklist> createState() => _RequirementChecklistState();
}

class _RequirementChecklistState extends State<RequirementChecklist> {
  bool _isAnalyzing = true;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    if (widget.analysis.requirementChecks.isEmpty &&
        widget.analysis.naturalResponse.isEmpty) {
      _isAnalyzing = false;
    } else {
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAnalyzing &&
        widget.analysis.requirementChecks.isEmpty &&
        widget.analysis.naturalResponse.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Widget cardContent;

    if (_isAnalyzing) {
      cardContent = Padding(
        key: const ValueKey('analyzing'),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SpinningTextLoader(
                texts: [
                  l10n.aiAnalyzingProfile,
                  l10n.aiTestingConstraints,
                  l10n.aiExtractingInsights,
                ],
                interval: const Duration(milliseconds: 1100),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      cardContent = ExpansionTile(
        key: const ValueKey('expanded'),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (val) {
          setState(() {
            _isExpanded = val;
          });
        },
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.analytics_outlined,
            color: colorScheme.onSurface,
            size: 20,
          ),
        ),
        title: Text(
          l10n.aiAnalysisTitle,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        shape: const Border(),
        collapsedShape: const Border(),
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          Divider(height: 1, color: colorScheme.outlineVariant),
          const SizedBox(height: 20),
          if (widget.analysis.naturalResponse.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                widget.analysis.naturalResponse,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (widget.analysis.requirementChecks.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.requirementsCheckLabel,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...widget.analysis.requirementChecks.map(
              (check) => _buildCheckItem(check),
            ),
          ],
        ],
      );
    }

    Widget innerContent = AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: cardContent,
    );

    return Card(
      elevation: colorScheme.brightness == Brightness.dark ? 0 : 4,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
      color: theme.cardTheme.color ?? colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: colorScheme.brightness == Brightness.dark
            ? BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: innerContent,
    );
  }

  Widget _buildCheckItem(RequirementCheck check) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check.isMet ? Icons.check_circle_outline : Icons.close_rounded,
            color: colorScheme.onSurface,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  check.field,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  check.message,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
