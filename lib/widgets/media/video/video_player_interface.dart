import 'package:flutter/material.dart';

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

  void dispose();
}
