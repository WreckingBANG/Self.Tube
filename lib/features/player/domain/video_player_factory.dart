import 'dart:io';
import 'package:Self.Tube/core/data/services/settings/settings_service.dart';
import 'adapters/vp-adapter.dart';
import 'adapters/mk-adapter.dart';
import 'video_player_interface.dart';

class MediaPlayerFactory {
  static MediaPlayer create(String url, {Map<String, String>? headers}) {
    if (Platform.isAndroid && SettingsService.vpUseMediaKit == false) {
      return VideoPlayerAdapter(url, headers: headers);
    } else {
      return MediaKitAdapter(url, headers: headers);
    }
  }
}

