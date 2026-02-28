import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../../domain/entities/tailor_analysis.dart';
import '../../../common/widgets/spinning_text_loader.dart';

class RequirementChecklist extends StatefulWidget {
  final TailorAnalysis analysis;
  final bool isDark;

  const RequirementChecklist({
    super.key,
    required this.analysis,
    required this.isDark,
  });

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

    final isDark = widget.isDark;
    final l10n = AppLocalizations.of(context)!;

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
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.white : Colors.black,
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),
                shimmerColors: isDark
                    ? [Colors.grey.shade700, Colors.white, Colors.grey.shade700]
                    : [Colors.grey.shade400, Colors.black, Colors.grey.shade400],
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
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.analytics_outlined,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          l10n.aiAnalysisTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'Outfit',
          ),
        ),
        shape: const Border(),
        collapsedShape: const Border(),
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          Divider(height: 1, color: isDark ? Colors.white12 : Colors.grey[200]),
          const SizedBox(height: 20),
          if (widget.analysis.naturalResponse.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
              child: Text(
                widget.analysis.naturalResponse,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
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
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
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

    if (isDark) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: CustomPaint(
              painter: _LiquidGlassCardPainter(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: innerContent,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      color: Theme.of(context).cardTheme.color ?? Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: innerContent,
    );
  }

  Widget _buildCheckItem(RequirementCheck check) {
    final isDark = widget.isDark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check.isMet ? Icons.check_circle_outline : Icons.close_rounded,
            color: isDark ? Colors.white : Colors.black,
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
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  check.message,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
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

class _LiquidGlassCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: const Radius.circular(24),
      bottomRight: const Radius.circular(24),
    );

    final specularPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -1.2),
        radius: 1.5,
        colors: [
          Colors.white.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, specularPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(rect);
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
