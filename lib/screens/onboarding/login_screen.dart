import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/settings_service.dart';
import '../../main.dart';
import '../../services/api_service.dart';

class OnBoardingLoginScreen extends StatefulWidget {
  @override
  _OnBoardingLoginScreenState createState() => _OnBoardingLoginScreenState();
}

class _OnBoardingLoginScreenState extends State<OnBoardingLoginScreen> {
  final TextEditingController _instanceUrlController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();

  Future<void> _saveSettings() async {
    await SettingsService.setInstanceUrl(_instanceUrlController.text);
    await SettingsService.setApiToken(_apiTokenController.text);
    await SettingsService.setDoneSetup(true);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.onboardingLogin)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _instanceUrlController,
              decoration: InputDecoration(
                labelText: localizations.settingsInstanceUrl,
                hint: Text(localizations.onboardingUrlExample),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _apiTokenController,
              decoration: InputDecoration(
                labelText: localizations.settingsApiToken,
                hint: Text(localizations.onboardingTokenExample),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        onPressed: () async {
          final ping = await ApiService.testConnection(
            _apiTokenController.text,
            _instanceUrlController.text,
          );

          if (ping != null && ping.response == 'pong') {
            await _saveSettings();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.onboardingLoginFailure)),
            );
          }
        },
        label: Text(localizations.onboardingLogin),
      ),
    );
  }
}
