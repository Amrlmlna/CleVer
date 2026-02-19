import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Legal Information'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Privacy Policy'),
              Tab(text: 'Terms'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LegalContent(markdown: kPrivacyPolicy),
            _LegalContent(markdown: kTermsConditions),
          ],
        ),
      ),
    );
  }
}

class _LegalContent extends StatelessWidget {
  final String markdown;
  const _LegalContent({required this.markdown});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdown,
      selectable: true,
      padding: const EdgeInsets.all(16),
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        h2: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, height: 2),
        p: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
    );
  }
}

const String kPrivacyPolicy = '''
# Privacy Policy

This privacy policy applies to the clever app for mobile devices created by Clever Labs as a Freemium service.

## Information Collection and Use
The Application collects information when you download and use it, including:
- Device IP address
- Pages visited and time spent
- Operating system version

## Geolocation & AI
- **Geolocation**: Used for personalized recommendations and services.
- **AI**: Technologies are used to enhance user experience and provide automated functionalities.

## Third Party Access
Anonymized data is transmitted to:
- [RevenueCat](https://www.revenuecat.com/privacy)

## Security
We provide procedural safeguards to protect the confidentiality of your information.

## Contact
cvfast-contact@gmail.com
''';

const String kTermsConditions = '''
# Terms & Conditions

By downloading the Application, you agree to these terms.

## Intellectual Property
Unauthorized copying or modification of the Application is prohibited. Source code extraction is not permitted.

## Responsibilities
- Users are responsible for maintaining device security.
- We are not responsible for functions requiring an active internet connection if access is unavailable.

## AI Usage
You acknowledge that AI is used to deliver functionalities and process data.

## Termination
We reserve the right to cease providing the application at any time.
''';

// Alias for compatibility
const String kTermsOfService = kTermsConditions;
