import 'package:flutter/material.dart';
import 'package:Self.Tube/main.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/ui/widgets/sections/login_section.dart';

class OnBoardingLoginScreen extends StatefulWidget {
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (route) => false,
                  );
                },
                label: Text(localizations.onboardingLogin),
              )
            : SizedBox.shrink(),
    );
  }
}
