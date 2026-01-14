import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/core/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class OnBoardingPrivacyPolicyScreen extends StatelessWidget {
  const OnBoardingPrivacyPolicyScreen({super.key});


  @override
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
          Navigator.pushNamed(
            context, 
            AppRouter.onboardingLogin
          );
        },
        label: Text(localizations.onboardingContinue),
      ),
    );
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(privacyPolicyUrl)) {
      throw Exception('Could not launch $privacyPolicyUrl');
    }
  }
}
