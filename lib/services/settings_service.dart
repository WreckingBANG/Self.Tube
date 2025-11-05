import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _instanceUrlKey = 'instanceUrl';
  static const _apiTokenKey = 'apiToken';
  static const _showCommentPics = 'showCommentPics';
  static const _doneSetup = 'doneSetup';

  static const _sponsorBlockEnabledKey = 'sponsorBlockEnabled';
  static const _sponsorKey = 'sbSponsor';
  static const _selfPromoKey = 'sbSelfpromo';
  static const _interactionKey = 'sbInteraction';
  static const _introKey = 'sbIntro';
  static const _outroKey = 'sbOutro';
  static const _previewKey = 'sbPreview';
  static const _hookKey = 'sbHook';
  static const _fillerKey = 'sbFiller';

  static String? instanceUrl;
  static String? apiToken;
  static bool? showCommentPics;
  static bool? doneSetup;

  static bool? sponsorBlockEnabled;
  static bool? sbSponsor;
  static bool? sbSelfpromo;
  static bool? sbInteraction;
  static bool? sbIntro;
  static bool? sbOutro;
  static bool? sbPreview;
  static bool? sbHook;
  static bool? sbFiller;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    instanceUrl = prefs.getString(_instanceUrlKey);
    apiToken = prefs.getString(_apiTokenKey);
    showCommentPics = prefs.getBool(_showCommentPics);
    doneSetup = prefs.getBool(_doneSetup);

    sponsorBlockEnabled = prefs.getBool(_sponsorBlockEnabledKey);
    sbSponsor = prefs.getBool(_sponsorKey);
    sbSelfpromo = prefs.getBool(_selfPromoKey);
    sbInteraction = prefs.getBool(_interactionKey);
    sbIntro = prefs.getBool(_introKey);
    sbOutro = prefs.getBool(_outroKey);
    sbPreview = prefs.getBool(_previewKey);
    sbHook = prefs.getBool(_hookKey);
    sbFiller = prefs.getBool(_fillerKey);
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

  static Future<void> setDoneSetup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_doneSetup, value);
    doneSetup = value;
  }

  static Future<void> setSponsorBlockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sponsorBlockEnabledKey, value);
    sponsorBlockEnabled = value;
  }

  static Future<void> setSponsorCategory(String category, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(category, value);

    switch (category) {
      case _sponsorKey:
        sbSponsor = value;
        break;
      case _selfPromoKey:
        sbSelfpromo = value;
        break;
      case _interactionKey:
        sbInteraction = value;
        break;
      case _introKey:
        sbIntro = value;
        break;
      case _outroKey:
        sbOutro = value;
        break;
      case _previewKey:
        sbPreview = value;
        break;
      case _hookKey:
        sbHook = value;
        break;
      case _fillerKey:
        sbFiller = value;
        break;
    }
  }
}
