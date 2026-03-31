import 'dart:io';
import 'package:Self.Tube/features/player/domain/codec_support.dart';
import 'adapters/vp-adapter.dart';
import 'adapters/mk-adapter.dart';
import 'video_player_interface.dart';

class MediaPlayerFactory {
  static late final Map<String, bool> _codecSupport;

  static Future<void> init() async {
    if (Platform.isAndroid) {
      _codecSupport = {
        'av1': await CodecSupport.supports('video/av01'),
        'vp9': await CodecSupport.supports('video/x-vnd.on2.vp9'),
        'h264': await CodecSupport.supports('video/avc'),
        'avc1': await CodecSupport.supports('video/avc'),
        'avc': await CodecSupport.supports('video/avc'),
        'h265': await CodecSupport.supports('video/hevc'),
        'hevc': await CodecSupport.supports('video/hevc'),
        'hev1': await CodecSupport.supports('video/hevc'),
        'hvc1': await CodecSupport.supports('video/hevc'),
      };
    } 
  }

  static MediaPlayer create(String url, String codec, {Map<String, String>? headers}) {
    if (Platform.isAndroid) {
      final supported = _codecSupport[codec.toLowerCase()] ?? false;
      if (supported) {
        print("usesVideoPlayer");
        return VideoPlayerAdapter(url, headers: headers);
      } else {
        print("usesMediaKit");
        return MediaKitAdapter(url, headers: headers);
      }
    } else {
      return MediaKitAdapter(url, headers: headers);
    }
  }
}

