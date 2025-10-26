import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _instanceUrlKey = 'instanceUrl';
  static const _apiTokenKey = 'apiToken';

  static String? instanceUrl;
  static String? apiToken;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    instanceUrl = prefs.getString(_instanceUrlKey);
    apiToken = prefs.getString(_apiTokenKey);
  }

  static Future<void> setInstanceUrl(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_instanceUrlKey, value);
    instanceUrl = value;
  }

  static Future<void> setApiToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiTokenKey, value);
    apiToken = value;
  }
}
