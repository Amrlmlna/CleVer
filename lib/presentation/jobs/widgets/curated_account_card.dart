import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../domain/entities/curated_account.dart';

class CuratedAccountCard extends StatelessWidget {
  final CuratedAccount account;

  const CuratedAccountCard({super.key, required this.account});

  Future<void> _launchInstagram(BuildContext context) async {
    final url = Uri.parse(account.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          AppLocalizations.of(context)!.jobCouldNotOpen,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _launchInstagram(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF833AB4),
                        Color(0xFFFD1D1D),
                        Color(0xFFF56040),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: account.profileImageUrl != null
                      ? Image.network(
                          account.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            color: colorScheme.onSurfaceVariant,
                            size: 28,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: colorScheme.onSurfaceVariant,
                          size: 28,
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  account.name,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  account.handle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (account.tags.isNotEmpty)
                  _AccountTag(tag: account.tags.first),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountTag extends StatelessWidget {
  final String tag;
  const _AccountTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Text(
        tag,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
