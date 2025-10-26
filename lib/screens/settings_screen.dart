import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _instanceUrlController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _instanceUrlController.text = SettingsService.instanceUrl ?? '';
    _apiTokenController.text = SettingsService.apiToken ?? '';
  }

  Future<void> _saveSettings() async {
    await SettingsService.setInstanceUrl(_instanceUrlController.text);
    await SettingsService.setApiToken(_apiTokenController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _instanceUrlController,
              decoration: InputDecoration(
                labelText: 'Instance URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _apiTokenController,
              decoration: InputDecoration(
                labelText: 'API Token',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
