import 'package:flutter/material.dart';

enum BorderMode { 
  contain,
  cover,
  stretch,
}

enum PlaybackSpeed {
  x0_25(0.25),
  x0_5(0.5),
  x0_75(0.75),
  x1_0(1.0),
  x1_25(1.25),
  x1_5(1.5),
  x1_75(1.75),
  x2_0(2.0);

  final double value;
  const PlaybackSpeed(this.value);
}

abstract class MediaPlayer {
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);

  bool get isPlaying;

  Widget buildView();
  Duration get position;
  Duration get duration;

  Stream<Duration> get positionStream;
  Stream<bool> get playingStream;

  ValueNotifier<bool> get repeatNotifier;
  Future<void> setRepeat(bool value);

  ValueNotifier<BorderMode> get borderModeNotifier; 
  Future<void> setBorderMode(BorderMode mode);

  ValueNotifier<PlaybackSpeed> get speedNotifier;
  Future<void> setPlaybackSpeed(PlaybackSpeed speed);

  void dispose();
}

