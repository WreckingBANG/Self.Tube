import 'dart:io';
import 'adapters/vp-adapter.dart';
import 'adapters/mk-adapter.dart';
import 'video_player_interface.dart';
import 'package:Self.Tube/data/services/settings_service.dart';

class MediaPlayerFactory {
  static MediaPlayer create(String url, {Map<String, String>? headers}) {
    if (Platform.isAndroid && SettingsService.vpUseMediaKit == false) {
      return VideoPlayerAdapter(url, headers: headers);
    } else {
      return MediaKitAdapter(url, headers: headers);
    }
  }
}

