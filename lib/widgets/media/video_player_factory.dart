import 'dart:io';
import 'video/adapters/vp-adapter.dart';
import 'video/adapters/mk-adapter.dart';
import 'video_player_interface.dart';
import 'package:Self.Tube/services/settings_service.dart';

class MediaPlayerFactory {
  static MediaPlayer create(String url, {Map<String, String>? headers}) {
    if (Platform.isAndroid && SettingsService.vpUseMediaKit == false) {
      return VideoPlayerAdapter(url, headers: headers);
    } else {
      return MediaKitAdapter(url, headers: headers);
    }
  }
}

