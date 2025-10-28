import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../l10n/generated/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _instanceUrlController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();
  bool _showCommentPics = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _instanceUrlController.text = SettingsService.instanceUrl ?? '';
    _apiTokenController.text = SettingsService.apiToken ?? '';
    _showCommentPics = SettingsService.showCommentPics?? false;
  }

  Future<void> _saveSettings() async {
    final localizations = AppLocalizations.of(context)!;
    await SettingsService.setInstanceUrl(_instanceUrlController.text);
    await SettingsService.setApiToken(_apiTokenController.text);
    await SettingsService.setShowCommentPics(_showCommentPics);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.settingsSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _instanceUrlController,
              decoration: InputDecoration(
                labelText: localizations.settingsInstanceUrl,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _apiTokenController,
              decoration: InputDecoration(
                labelText: localizations.settingsApiToken,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text(localizations.settingsSave),
            ),
            SwitchListTile(
              title: Text(localizations.settingsShowCommentPics),
              value: _showCommentPics,
              onChanged: (bool value) {
                setState(() {
                  _showCommentPics = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
