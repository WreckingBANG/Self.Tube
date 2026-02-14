import 'dart:async';
import 'package:Self.Tube/features/player/domain/audio_service.dart';
import 'package:Self.Tube/features/player/domain/sponsorblock_service.dart';
import 'package:Self.Tube/features/player/ui/screens/player_screen.dart';
import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Self.Tube/common/data/services/api/api_headers.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/features/player/data/api/player_api.dart';
import 'package:Self.Tube/features/player/data/models/videoplayer_model.dart';
import 'package:Self.Tube/features/player/domain/video_player_factory.dart';
import 'package:Self.Tube/features/player/domain/video_player_interface.dart';
import 'package:Self.Tube/features/player/ui/video_player_ui.dart';
import 'package:flutter/material.dart';

class VideoPlayerService {
  static MediaPlayer? _player;
  static final currentVideo = ValueNotifier<VideoPlayerModel?>(null);
  static String? instanceUrl = SettingsService.instanceUrl;
  static StreamSubscription? _reportPos;
  static StreamSubscription? _sbPos;
  static late MediaSessionHandler mediaSession;


  static Future<void> init() async {
    MediaKit.ensureInitialized();
    mediaSession = await MediaSessionHandler.create();
  } 

  static void loadVideo(String id, bool fullscreen, BuildContext context) async {
    disposeVideo();
    
    final video = await PlayerApi.fetchVideoPlayer(id);
    currentVideo.value = video;
    if (video == null) return;
   
    if (SettingsService.sponsorBlockEnabled!) {
      SponsorblockService.init(video);
    }

    if (fullscreen) {
      openPlayer(context);
    }

    _player = MediaPlayerFactory.create(
      "$instanceUrl${video.videoUrl}",
      headers: ApiHeaders.authHeaders(),
    );
    await _player?.initialized;

    mediaSession.attachPlayer(_player!);
    mediaSession.updateMetadata(video);

    await _player?.seek(Duration(seconds: video.videoPosition.toInt()));

    periodicActions(video.videoId);
    mediaSession.play();
  }

  static void openPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints.expand(),
      builder: (_) {
        return PlayerScreen(video: currentVideo.value);
      },
    );
  }

  static void periodicActions(id) {
    _reportPos?.cancel();
    _sbPos?.cancel();

    _reportPos = player?.positionStream
      .throttleTime(Duration(seconds: 10))
      .listen((position) {
        PlayerApi.setVideoProgress(id, _player?.position.inSeconds.toInt() ?? 0);
      });
    
    if (SettingsService.sponsorBlockEnabled!) {
      _sbPos = player?.positionStream
        .throttleTime(Duration(seconds: 1))
        .listen((position) {
          SponsorblockService.checkTimestamp(position);
        }
      );
    }
  }

  static void disposeVideo() {
    _player?.dispose();
    _reportPos?.cancel();
    _sbPos?.cancel();
    mediaSession.dispose();
    SponsorblockService.dispose();
    currentVideo.value = null;
  }

  static Widget buildUI({
    required String title,
    required String creator,
  }) {
    if (_player == null) {
      return const Center(child: Text("No video loaded"));
    }

    return VideoPlayerUI(
      player: _player!,
      videoCreator: creator,
      videoTitle: title,
    );
  }

  static MediaPlayer? get player => _player;
}
