import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../video_player_interface.dart';

class VideoPlayerAdapter implements MediaPlayer {
  final VideoPlayerController _controller;

  final _positionController = StreamController<Duration>.broadcast();
  final _playingController = StreamController<bool>.broadcast();

  Duration? _lastPosition;
  bool? _lastPlaying;

  int _lastEmitMs = 0;
  bool _disposed = false;

  final ValueNotifier<bool> _repeatNotifier = ValueNotifier(false);
  final ValueNotifier<BorderMode> _borderModeNotifier = ValueNotifier(BorderMode.contain);
  final ValueNotifier<PlaybackSpeed> _speedNotifier = ValueNotifier(PlaybackSpeed.x1_0);

  VideoPlayerAdapter(String url, {Map<String, String>? headers})
      : _controller = VideoPlayerController.networkUrl(
          Uri.parse(url),
          httpHeaders: headers ?? const {},
        ) {
    _controller.initialize().then((_) {
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

    if (_repeatNotifier.value && value.position >= value.duration) { 
      _controller.seekTo(Duration.zero); 
      _controller.play(); 
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
    return ValueListenableBuilder<BorderMode>(
      valueListenable: _borderModeNotifier,
      builder: (context, mode, _) {
        if (!_controller.value.isInitialized) {
          return const SizedBox.shrink();
        }

        final size = _controller.value.size;

        return SizedBox.expand(
          child: FittedBox(
            fit: _mapBorderMode(mode),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: VideoPlayer(_controller),
            ),
          ),
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

  @override
  ValueNotifier<PlaybackSpeed> get speedNotifier => _speedNotifier;

  @override
  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    _speedNotifier.value = speed;
    await _controller.setPlaybackSpeed(speed.value);
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _positionController.close();
    _playingController.close();
  }
}
