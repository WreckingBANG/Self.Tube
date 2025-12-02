import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../video_player_interface.dart';

class VideoPlayerAdapter implements MediaPlayer {
  final VideoPlayerController _controller;

  VideoPlayerAdapter(String url, {Map<String, String>? headers})
      : _controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          httpHeaders: headers ?? const {},
        ) {
    _controller.initialize();
  }

  @override
  Widget buildView() {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }

  @override
  Duration get position => _controller.value.position;

  @override
  Duration get duration => _controller.value.duration;

  @override
  Future<void> play() => _controller.play();

  @override
  Future<void> pause() => _controller.pause();

  @override
  Future<void> seek(Duration position) => _controller.seekTo(position);

  @override
  Stream<Duration> get positionStream =>
    Stream.periodic(const Duration(milliseconds: 500), (_) {
      return _controller.value.position;
    });

  @override
  bool get isPlaying => _controller.value.isPlaying;

  @override
  void dispose() => _controller.dispose();
}
