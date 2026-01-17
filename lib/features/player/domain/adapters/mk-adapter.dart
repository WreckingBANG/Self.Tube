import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../video_player_interface.dart';

class MediaKitAdapter implements MediaPlayer {
  final Player _player;
  late final VideoController _videoController;
  late final Widget _videoView;

  final ValueNotifier<bool> _repeatNotifier = ValueNotifier(false);
  final ValueNotifier<BorderMode> _borderModeNotifier = ValueNotifier(BorderMode.contain);

  MediaKitAdapter(String url, {Map<String, String>? headers})
      : _player = Player() {
    _player.open(
      Media(url, httpHeaders: headers),
    );

    _player.stream.completed.listen((_) {
      if (_repeatNotifier.value) { 
        _player.seek(Duration.zero); 
         _player.play();
      } 
    });

    _videoController = VideoController(_player);
    _videoView = ValueListenableBuilder<BorderMode>(
      valueListenable: _borderModeNotifier,
      builder: (context, mode, _) {
        return Video(
          controller: _videoController,
          controls: null,
          fit: _mapBorderMode(mode),
        );
      },
    );
  }

  BoxFit _mapBorderMode(BorderMode mode) {
    switch (mode) {
      case BorderMode.contain:
        return BoxFit.contain;
      case BorderMode.cover:
        return BoxFit.cover;
      case BorderMode.stretch:
        return BoxFit.fill;
    }
  }

  @override
  Widget buildView() => _videoView;

  @override
  Duration get position => _player.state.position;

  @override
  Duration get duration => _player.state.duration;

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) async {
    if (position < Duration.zero) {
      return _player.seek(Duration.zero);
    } else if (position > duration) {
      return _player.seek(duration);
    } else {
      return _player.seek(position);
    }
  }

  @override
  Stream<Duration> get positionStream => _player.stream.position;

  @override
  Stream<bool> get playingStream => _player.stream.playing.asBroadcastStream();

  @override
  bool get isPlaying => _player.state.playing;

  @override 
  ValueNotifier<bool> get repeatNotifier => _repeatNotifier;

  @override
  Future<void> setRepeat(bool value) async {
    _repeatNotifier.value = value;
  }

  @override 
  ValueNotifier<BorderMode> get borderModeNotifier => _borderModeNotifier; 
  
  @override 
  Future<void> setBorderMode(BorderMode mode) async { 
    _borderModeNotifier.value = mode; 
  } 

  final ValueNotifier<PlaybackSpeed> _speedNotifier =
      ValueNotifier(PlaybackSpeed.x1_0);

  @override
  ValueNotifier<PlaybackSpeed> get speedNotifier => _speedNotifier;

  @override
  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    _speedNotifier.value = speed;
    _player.setRate(speed.value);
  }
  
  @override
  void dispose() => _player.dispose();
}
