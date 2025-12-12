import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../video_player_interface.dart';

class MediaKitAdapter implements MediaPlayer {
  final Player _player;
  late final VideoController _videoController;
  late final Widget _videoView;

  MediaKitAdapter(String url, {Map<String, String>? headers})
      : _player = Player() {
    _player.open(
      Media(url, httpHeaders: headers),
    );
    _videoController = VideoController(_player);
    _videoView = Video(controller: _videoController, controls: null);
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
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Stream<Duration> get positionStream => _player.stream.position;

  @override
  Stream<bool> get playingStream => _player.stream.playing.asBroadcastStream();

  @override
  bool get isPlaying => _player.state.playing;

  @override
  void dispose() => _player.dispose();
}
