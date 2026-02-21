import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/faq_item.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  Future<void> _contactSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'cvfast.contact@gmail.com',
      query: 'subject=Bantuan Aplikasi CV Master&body=Halo tim support, saya butuh bantuan...',
    );

    if (!await launchUrl(emailLaunchUri)) {
      if (mounted) {
         CustomSnackBar.showError(context, AppLocalizations.of(context)!.cantOpenEmail);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helpSupport),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _SupportCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: AppLocalizations.of(context)!.contactSupport,
                    onTap: _contactSupport,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SupportCard(
                    icon: Icons.feedback_outlined,
                    title: AppLocalizations.of(context)!.feedback,
                    subtitle: AppLocalizations.of(context)!.suggestionsBugs,
                    onTap: () => context.push('/support/feedback'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 48),
            const SizedBox(height: 48),
            Text(
              AppLocalizations.of(context)!.frequentQuestions,
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            FAQItem(
              question: AppLocalizations.of(context)!.faqFreeQuestion,
              answer: AppLocalizations.of(context)!.faqFreeAnswer,
            ),
            FAQItem(
              question: AppLocalizations.of(context)!.faqEditQuestion,
              answer: AppLocalizations.of(context)!.faqEditAnswer,
            ),
             FAQItem(
              question: AppLocalizations.of(context)!.faqDataQuestion,
              answer: AppLocalizations.of(context)!.faqDataAnswer,
            ),
            FAQItem(
              question: AppLocalizations.of(context)!.faqPdfQuestion,
              answer: AppLocalizations.of(context)!.faqPdfAnswer,
            ),

            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Image.asset('assets/icon/icon.png', width: 48, height: 48, errorBuilder: (context, error, stackTrace) => const Icon(Icons.description, size: 48, color: Colors.grey))
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'CV Master $_appVersion',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.push('/legal/privacy'),
                        child: Text(AppLocalizations.of(context)!.privacyPolicy, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ),
                      Text('|', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                      TextButton(
                        onPressed: () => context.push('/legal/terms'),
                        child: Text(AppLocalizations.of(context)!.termsOfService, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ),
                    ],
                  )
                ],
              ),
            ),
             const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withValues(alpha: 0.1),
             offset: const Offset(0, 4),
             blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 16),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
