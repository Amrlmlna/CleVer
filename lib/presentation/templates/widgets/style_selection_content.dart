import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../providers/template_selection_controller.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/utils/subscription_formatter.dart';
import 'template_grid_item.dart';
import 'dart:async';

class StyleSelectionContent extends ConsumerWidget {
  final VoidCallback onExport;

  const StyleSelectionContent({super.key, required this.onExport});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templateSelectionControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return AppLoadingScreen(
        badge: AppLocalizations.of(context)!.loadingTemplatesBadge,
        messages: [
          AppLocalizations.of(context)!.fetchingTemplates,
          AppLocalizations.of(context)!.preparingGallery,
          AppLocalizations.of(context)!.loadingPreview,
        ],
      );
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    final templates = state.templates;
    final selectedStyleId = state.selectedStyleId;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.selectTemplate,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          if (templates.isNotEmpty)
            _SubscriptionBadge(
              isSubscribed: templates.any((t) => t.isSubscribed),
              expiryDate: templates.first.subscriptionExpiry,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 20,
                mainAxisSpacing: 24,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return TemplateGridItem(
                  template: template,
                  isSelected: template.id == selectedStyleId,
                  onTap: () async {
                    if (template.isLocked) {
                      final purchased = await PaymentService.presentPaywall(
                        context,
                      );
                      if (purchased) {
                        ref.invalidate(templateSelectionControllerProvider);
                      }
                    } else {
                      ref
                          .read(templateSelectionControllerProvider.notifier)
                          .selectStyle(template.id);
                    }
                  },
                );
              },
            ),
          ),
          _BottomExportButton(
            onPressed: onExport,
            label: AppLocalizations.of(context)!.previewTemplate,
          ),
        ],
      ),
    );
  }
}

class _SubscriptionBadge extends StatefulWidget {
  final bool isSubscribed;
  final DateTime? expiryDate;

  const _SubscriptionBadge({required this.isSubscribed, this.expiryDate});

  @override
  State<_SubscriptionBadge> createState() => _SubscriptionBadgeState();
}

class _SubscriptionBadgeState extends State<_SubscriptionBadge> {
  Timer? _timer;
  String _timeLeft = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateTimeLeft();
        _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
          if (mounted) _updateTimeLeft();
        });
      }
    });
  }

  @override
  void didUpdateWidget(_SubscriptionBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expiryDate != widget.expiryDate ||
        oldWidget.isSubscribed != widget.isSubscribed) {
      _updateTimeLeft();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeLeft() {
    if (!widget.isSubscribed || widget.expiryDate == null) {
      if (mounted) setState(() => _timeLeft = '');
      return;
    }

    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    final timeStr = SubscriptionFormatter.formatRemainingTime(
      widget.expiryDate!,
      l10n,
    );

    if (mounted) setState(() => _timeLeft = timeStr);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isSubscribed
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSubscribed
                  ? colorScheme.primary.withValues(alpha: 0.3)
                  : colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isSubscribed ? Icons.bolt_rounded : Icons.stars_rounded,
                size: 14,
                color: widget.isSubscribed
                    ? colorScheme.primary
                    : colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(
                widget.isSubscribed
                    ? (_timeLeft.isEmpty
                          ? l10n.active.toUpperCase()
                          : _timeLeft.toUpperCase())
                    : l10n.free.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: widget.isSubscribed
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomExportButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _BottomExportButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.onSurface,
              foregroundColor: colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
