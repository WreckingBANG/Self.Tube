import 'dart:io';
import 'package:Self.Tube/common/data/services/api/api_headers.dart';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/utils/duration_formatter.dart';
import 'package:Self.Tube/features/player/data/api/player_api.dart';
import 'package:Self.Tube/features/player/ui/video_player_ui.dart';
import 'package:Self.Tube/features/player/data/audio/audio_player_handler.dart';
import 'package:Self.Tube/main.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'video_player_interface.dart';
import 'video_player_factory.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoTitle;
  final String videoCreator;
  final String youtubeId;
  final String videoUrl;
  final String videoThumbnail;
  final double videoPosition;
  final List<dynamic>? sponsorSegments;

  const CustomVideoPlayer({
    super.key,
    required this.videoTitle,
    required this.videoCreator,
    required this.youtubeId,
    required this.videoUrl,
    required this.videoThumbnail,
    required this.videoPosition,
    this.sponsorSegments,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final MediaPlayer _player;
  Duration _lastReportedPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<bool>? _playStateSubscription;
  bool _restoringInitialPosition = true;

  Duration _lastCheck = Duration.zero;
  final Duration _checkInterval = const Duration(milliseconds: 1000);

  static String? baseUrl = SettingsService.instanceUrl;

  late final Map<String, bool> _categoryEnabledMap;

  final Set<String> _unskippedSegments = {};

  @override
  void initState() {
    super.initState();
    DeviceService.setWakeLock(true);
    _player = MediaPlayerFactory.create(
      '$baseUrl${widget.videoUrl}',
      headers: ApiHeaders.authHeaders()
    );
    
    BackgroundAudioHandler.currentInternalPlayer = _player;

    audioHandler.mediaItem.add(MediaItem(
      id: widget.youtubeId,
      album: widget.videoCreator,
      title: widget.videoTitle,
      artist: widget.videoCreator,
      duration: _player.duration,
    ));

    _initBackgroundAudio();

    _playStateSubscription = _player.playingStream.listen((playing) {
      audioHandler.syncStateWithPlayer(_player);
      if (audioHandler.mediaItem.value?.duration == Duration.zero && _player.duration > Duration.zero) {
        _updateMediaMetadata();
      }
    });

    _updateMediaMetadata();

    _categoryEnabledMap = {
      'sponsor': SettingsService.sbSponsor ?? false,
      'selfpromo': SettingsService.sbSelfpromo ?? false,
      'interaction': SettingsService.sbInteraction ?? false,
      'intro': SettingsService.sbIntro ?? false,
      'outro': SettingsService.sbOutro ?? false,
      'preview': SettingsService.sbPreview ?? false,
      'hook': SettingsService.sbHook ?? false,
      'filler': SettingsService.sbFiller ?? false,
    };

    _positionSubscription = _player.positionStream.listen(_onPosition);
  }

  Future<void> _updateMediaMetadata() async {
    Uri? localArtUri;
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${widget.youtubeId}.jpg');

      if (!await file.exists()) {
        final response = await http.get(
          Uri.parse("${SettingsService.instanceUrl}${widget.videoThumbnail}"),
          headers: ApiHeaders.authHeaders(),
        );
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          localArtUri = file.uri;
        }
      } else {
        localArtUri = file.uri;
      }
    } catch (e) {
      debugPrint("Thumbnail Error: $e");
    }

    if (!mounted) return;

    audioHandler.mediaItem.add(MediaItem(
      id: widget.youtubeId,
      album: widget.videoCreator,
      title: widget.videoTitle,
      artist: widget.videoCreator,
      duration: _player.duration,
      artUri: localArtUri,
    ));
  }


  Future<void> _initBackgroundAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    if (await session.setActive(true)) {
      audioHandler.syncStateWithPlayer(_player);
    }
  }

  void _onPosition(Duration position) {
    // throttle checks
    final deltaMs = (position - _lastCheck).inMilliseconds;
    if (deltaMs < _checkInterval.inMilliseconds) return;
    _lastCheck = position;

    final seconds = position.inSeconds;

    // restore starting position once
    if (_restoringInitialPosition &&
        widget.videoPosition > 0 &&
        seconds > 0) {
      _restoringInitialPosition = false;
      _player.seek(Duration(seconds: widget.videoPosition.toInt()));
      return;
    }

    // progress reporting every 10s
    if ((seconds - _lastReportedPosition.inSeconds).abs() >= 10) {
      _lastReportedPosition = position;
      VideoApi.setVideoProgress(widget.youtubeId, seconds);
    }

    // sponsor skipping
    if (SettingsService.sponsorBlockEnabled == true) {
      for (final segment in widget.sponsorSegments ?? []) {
        final start = segment.segment[0].round();
        final end = segment.segment[1].round();
        final category = segment.category.toLowerCase();
        final segmentId = "$start-$end-$category";

        if (_categoryEnabledMap[category] == true &&
            seconds >= start &&
            seconds < end &&
            !_unskippedSegments.contains(segmentId)) {
          
          _player.seek(Duration(seconds: end));

          final messenger = ScaffoldMessenger.of(context);

          final snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                if (_player.isPlaying != true) {
                  _player.play();
                }
                _unskippedSegments.add(segmentId);
                _player.seek(Duration(seconds: start - 1));
              },
            ),
            content: Row(
              children: [
                const Icon(Icons.money_off),
                Text(
                  "Skipped $category from ${formatDuration(start)} to ${formatDuration(end)}",
                ),
              ],
            ),
          );
          
          messenger.showSnackBar(snackBar);

          Future.delayed(const Duration(milliseconds: 1500), () {
            messenger.hideCurrentSnackBar();
          });
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    DeviceService.setWakeLock(false);
    _positionSubscription?.cancel();
    _playStateSubscription?.cancel();
    VideoApi.setVideoProgress(widget.youtubeId, _lastReportedPosition.inSeconds);
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerUI(
      player: _player,
      videoCreator: widget.videoCreator,
      videoTitle: widget.videoTitle,
    );
  }
}
