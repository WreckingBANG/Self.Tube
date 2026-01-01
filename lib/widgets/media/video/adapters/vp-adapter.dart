import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../video_player_interface.dart';

class VideoPlayerAdapter implements MediaPlayer {
  final VideoPlayerController _controller;
  late final Future<void> _initializeFuture;

  final _positionController = StreamController<Duration>.broadcast();
  final _playingController = StreamController<bool>.broadcast();

  Duration? _lastPosition;
  bool? _lastPlaying;

  int _lastEmitMs = 0;
  bool _disposed = false;

  VideoPlayerAdapter(String url, {Map<String, String>? headers})
      : _controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          httpHeaders: headers ?? const {},
        ) {
    _initializeFuture = _controller.initialize().then((_) {
      if (!_controller.value.isInitialized) return;

      final value = _controller.value;

      _lastPlaying = value.isPlaying;
      _lastPosition = value.position;

      _playingController.add(_lastPlaying!);
      _positionController.add(_lastPosition!);

      _controller.play();
      _controller.addListener(_onControllerUpdate);
    });
  }

  void _onControllerUpdate() {
    if (_disposed) return;

    final value = _controller.value;
    if (!value.isInitialized) return;

    if (value.isPlaying != _lastPlaying) {
      _lastPlaying = value.isPlaying;
      _playingController.add(value.isPlaying);
    }

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs - _lastEmitMs >= 150) {
      if (value.position != _lastPosition) {
        _lastPosition = value.position;
        _lastEmitMs = nowMs;
        _positionController.add(value.position);
      }
    }
  }

  @override
  Widget buildView() {
    return FutureBuilder(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _controller.value.isInitialized) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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
  Future<void> seek(Duration position) {
    final d = duration;
    final clamped = position < Duration.zero
        ? Duration.zero
        : (position > d ? d : position);
    return _controller.seekTo(clamped);
  }

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  bool get isPlaying => _controller.value.isPlaying;

  @override
  void dispose() {
    _disposed = true;
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _positionController.close();
    _playingController.close();
  }
}
