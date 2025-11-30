import 'dart:io';
import 'adapters/vp-adapter.dart';
import 'adapters/mk-adapter.dart';
import 'video_player_interface.dart';

class MediaPlayerFactory {
  static MediaPlayer create(String url, {Map<String, String>? headers}) {
    if (Platform.isAndroid) {
      return VideoPlayerAdapter(url, headers: headers);
    } else {
      return MediaKitAdapter(url, headers: headers);
    }
  }
}

