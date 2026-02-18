import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Self.Tube/common/data/services/database/database_service.dart';
import 'package:Self.Tube/common/data/dao/settings_dao.dart';

class SettingsService {
  static const FlutterSecureStorage _secure = FlutterSecureStorage();
  static final _db = AppDatabase();
  static final _dao = SettingsDao(_db);

  static const _instanceUrlKey = 'instanceUrl';
  static const _apiTokenAuth = 'apiTokenAuth';
  static const _apiTokenKey = 'apiToken';
  static const _sessionToken = 'sessionToken';
  static const _csrfToken = 'csrfToken';

  static const _showCommentPics = 'showCommentPics';
  static const _materialYouColors = 'materialYouColors';
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

  static const _vpGestureSwipe = 'vpGestureSwipe';
  static const _vpGestureFullscreen = 'vpGestureFullscreen';
  static const _vpGesturePinch = 'vpGesturePinch';
  static const _vpGestureDoubleTap = 'vpGestureDoubleTap';
  static const _vpUseMediaKit = 'vpUseMediaKit';

  static String? instanceUrl;
  static bool? apiTokenAuth;
  static String? apiToken;
  static String? sessionToken;
  static String? csrfToken;

  static bool? showCommentPics;
  static bool? materialYouColors;
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

  static bool? vpGestureSwipe;
  static bool? vpGestureFullscreen;
  static bool? vpGesturePinch;
  static bool? vpGestureDoubleTap;
  static bool? vpUseMediaKit;


  static Future<void> load() async {
    final data = await _dao.readAll();
  
    bool? b(String k, [bool? defaultValue]) => 
        data[k] == null ? defaultValue : data[k] == '1';
  
    instanceUrl = data[_instanceUrlKey];
    apiTokenAuth = b(_apiTokenAuth);
    doneSetup = b(_doneSetup);
    
    showCommentPics = b(_showCommentPics);
    materialYouColors = b(_materialYouColors, true);
  
    sponsorBlockEnabled = b(_sponsorBlockEnabledKey, true);
    sbSponsor = b(_sponsorKey, true);
    sbSelfpromo = b(_selfPromoKey);
    sbInteraction = b(_interactionKey);
    sbIntro = b(_introKey);
    sbOutro = b(_outroKey);
    sbPreview = b(_previewKey);
    sbHook = b(_hookKey);
    sbFiller = b(_fillerKey);
  
    vpGestureSwipe = b(_vpGestureSwipe, true);
    vpGestureFullscreen = b(_vpGestureFullscreen, true);
    vpGesturePinch = b(_vpGesturePinch, true);
    vpGestureDoubleTap = b(_vpGestureDoubleTap, true);
    vpUseMediaKit = b(_vpUseMediaKit, false);
  
    apiToken = await _secure.read(key: _apiTokenKey);
    sessionToken = await _secure.read(key: _sessionToken);
    csrfToken = await _secure.read(key: _csrfToken);
  }


  static Future<void> _persist(String key, dynamic value) async {
    final String str = value is bool ? (value ? '1' : '0') : value.toString();
    await _dao.write(key, str);
  }

  static Future<void> setInstanceUrl(String value) async {
    await _persist(_instanceUrlKey, value);
    instanceUrl = value;
  }

  static Future<void> setApiToken(String value) async {
    await _secure.write(key: _apiTokenKey, value: value);
    apiToken = value;
  }

  static Future<void> setApiTokenAuth(bool value) async {
    await _persist(_apiTokenAuth, value);
    apiTokenAuth = value;
  }

  static Future<void> setSessionToken(String value) async {
    await _secure.write(key: _sessionToken, value: value);
    sessionToken = value;
  }

  static Future<void> setCSRFToken(String value) async {
    await _secure.write(key: _csrfToken, value: value);
    csrfToken = value;
  }

  static Future<void> setShowCommentPics(bool value) async {
    await _persist(_showCommentPics, value);
    showCommentPics = value;
  }

  static Future<void> setMaterialYouColors(bool value) async {
    await _persist(_materialYouColors, value);
    materialYouColors = value;
  }

  static Future<void> setDoneSetup(bool value) async {
    await _persist(_doneSetup, value);
    doneSetup = value;
  }

  static Future<void> setSponsorBlockEnabled(bool value) async {
    await _persist(_sponsorBlockEnabledKey, value);
    sponsorBlockEnabled = value;
  }

  static Future<void> setSponsorCategory(String category, bool value) async {
    await _persist(category, value);

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

  static Future<void> setVPGestureSwipe(bool value) async {
    await _persist(_vpGestureSwipe, value);
    vpGestureSwipe = value;
  }

  static Future<void> setVPGestureFullscreen(bool value) async {
    await _persist(_vpGestureFullscreen, value);
    vpGestureFullscreen = value;
  }

  static Future<void> setVPGesturePinch(bool value) async {
    await _persist(_vpGesturePinch, value);
    vpGesturePinch = value;
  }

  static Future<void> setVPGestureDoubleTap(bool value) async {
    await _persist(_vpGestureDoubleTap, value);
    vpGestureDoubleTap = value;
  }

  static Future<void> setVPUseMediaKit(bool value) async {
    await _persist(_vpUseMediaKit, value);
    vpUseMediaKit = value;
  }
}

