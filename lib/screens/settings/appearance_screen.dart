import 'package:flutter/material.dart';
import '../../services/settings_service.dart';
import '../../l10n/generated/app_localizations.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  @override
  _AppearanceSettingsScreenState createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  bool _showCommentPics = false;
  bool _materialYouColors = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _showCommentPics = SettingsService.showCommentPics?? false;
    _materialYouColors = SettingsService.materialYouColors?? false;
  }

  Future<void> _saveSettings() async {
    final localizations = AppLocalizations.of(context)!;
    await SettingsService.setShowCommentPics(_showCommentPics);
    await SettingsService.setMaterialYouColors(_materialYouColors);
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
            SwitchListTile(
              title: Text(localizations.settingsShowCommentPics),
              value: _showCommentPics,
              onChanged: (bool value) {
                setState(() {
                  _showCommentPics = value;
                  _saveSettings();
                });
              },
            ),
            SwitchListTile(
              title: Text("Enable Material-You Colors"),
              value: _materialYouColors,
              onChanged: (bool value) {
                setState(() {
                  _materialYouColors = value;
                  _saveSettings();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
