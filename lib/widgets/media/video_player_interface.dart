import 'package:flutter/material.dart';

abstract class MediaPlayer {
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);

  Stream<Duration> get positionStream;
  bool get isPlaying;

  Widget buildView();
  Duration get position;
  Duration get duration;

  void dispose();
}
