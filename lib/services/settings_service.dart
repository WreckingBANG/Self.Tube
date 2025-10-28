import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _instanceUrlKey = 'instanceUrl';
  static const _apiTokenKey = 'apiToken';
  static const _showCommentPics = 'showCommentPics';

  static String? instanceUrl;
  static String? apiToken;
  static bool? showCommentPics;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    instanceUrl = prefs.getString(_instanceUrlKey);
    apiToken = prefs.getString(_apiTokenKey);
    showCommentPics = prefs.getBool(_showCommentPics);
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

  static Future<void> setShowCommentPics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showCommentPics, value);
    showCommentPics = value;
  }
}
