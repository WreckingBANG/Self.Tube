import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../video_player_interface.dart';

class MediaKitAdapter implements MediaPlayer {
  final Player _player;

  MediaKitAdapter(String url, {Map<String, String>? headers})
      : _player = Player() {
    _player.open(
      Media(
        url,
        httpHeaders: headers,
      ),
    );
  }

  @override
  Widget buildView() {
    return Video(controller: VideoController(_player), controls: null);
  }

@override
Duration get position => _player.state.position;

@override
Duration get duration => _player.state.duration;

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Stream<Duration> get positionStream => _player.stream.position;

  @override
  bool get isPlaying => _player.state.playing;

  @override
  void dispose() => _player.dispose();
}
