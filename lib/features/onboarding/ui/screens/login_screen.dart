import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/app/ui/shell/homecontainer_screen.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/onboarding/ui/widgets/login_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class OnBoardingLoginScreen extends StatefulWidget {
  const OnBoardingLoginScreen({super.key});

  @override
  _OnBoardingLoginScreenState createState() => _OnBoardingLoginScreenState();
}

class _OnBoardingLoginScreenState extends State<OnBoardingLoginScreen> {
  bool loginSuccessful = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.onboardingLogin)),
      body: Center(
        child: LoginSectionWidget(
            onLoginSuccess: () {
            setState(() {
              loginSuccessful = true;
            });
          },
        ),
      ),
      floatingActionButton: 
        loginSuccessful
            ? FloatingActionButton.extended(
                icon: Icon(Icons.check),
                onPressed: () async {
                  await SettingsService.load();
                  await UserSession.init();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.home,
                    (route) => false,
                  );
                },
                label: Text(localizations.onboardingLogin),
              )
            : SizedBox.shrink(),
    );
  }
}
