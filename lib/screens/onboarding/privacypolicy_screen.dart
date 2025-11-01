import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';

class OnBoardingPrivacyPolicyScreen extends StatelessWidget {
  final Uri privacypolicy_url = Uri.parse('https://codeberg.org/WreckingBANG/Self.Tube/src/branch/main/docs/PRIVACY_POLICY.md');

  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(

      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(localizations.onboardingWelcomeText),
            expandedHeight: 200,
            pinned: true,
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.onboardingMarketing1,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.archive),
                    title: Text(localizations.onboardingMarketing2),
                  ),
                  ListTile(
                    leading: Icon(Icons.video_library_rounded),
                    title: Text(localizations.onboardingMarketing3),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone_android),
                    title: Text(localizations.onboardingMarketing4),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {_launchUrl();},
                    child: Text(localizations.onboardingPrivacyPolicy),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnBoardingLoginScreen()),
          );
        },
        label: Text(localizations.onboardingContinue),
      ),
    );
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(privacypolicy_url)) {
      throw Exception('Could not launch $privacypolicy_url');
    }
  }
}
