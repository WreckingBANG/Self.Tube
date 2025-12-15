import 'dart:async';
import 'package:flutter/material.dart';
import 'video_player_interface.dart';
import 'video_player_factory.dart';
import 'package:Self.Tube/services/api_service.dart';
import 'package:Self.Tube/services/settings_service.dart';
import 'package:Self.Tube/utils/duration_formatter.dart';
import 'video_player_ui.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoTitle;
  final String videoCreator;
  final String youtubeId;
  final String videoUrl;
  final double videoPosition;
  final List<dynamic>? sponsorSegments;

  const CustomVideoPlayer({
    Key? key,
    required this.videoTitle,
    required this.videoCreator,
    required this.youtubeId,
    required this.videoUrl,
    required this.videoPosition,
    this.sponsorSegments,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final MediaPlayer _player;
  Duration _lastReportedPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;

  // throttle fields
  Duration _lastCheck = Duration.zero;
  final Duration _checkInterval = const Duration(milliseconds: 1000);

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  late final Map<String, bool> _categoryEnabledMap;

  final Set<String> _unskippedSegments = {};

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _player = MediaPlayerFactory.create(
      '$baseUrl${widget.videoUrl}',
      headers: {
        'Authorization': 'token $apiToken',
      },
    );

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

    // start playback immediately
    _player.play();
  }

  void _onPosition(Duration position) {
    // throttle checks
    final deltaMs = (position - _lastCheck).inMilliseconds;
    if (deltaMs < _checkInterval.inMilliseconds) return;
    _lastCheck = position;

    final seconds = position.inSeconds;

    // restore starting position once
    if (widget.videoPosition > 0 &&
        _lastReportedPosition == Duration.zero &&
        seconds > 0) {
      _player.seek(Duration(seconds: widget.videoPosition.toInt()));
    }

    // progress reporting every 10s
    if ((seconds - _lastReportedPosition.inSeconds).abs() >= 10) {
      _lastReportedPosition = position;
      ApiService.setVideoProgress(widget.youtubeId, seconds);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1500),
              action: SnackBarAction(
                label: "Undo", 
                onPressed: () {
                  if (_player.isPlaying != true) { _player.play(); }
                  _unskippedSegments.add(segmentId);
                  _player.seek(Duration(seconds: start - 1));
                }
              ),
              content: Row(
                children: [
                  Icon(Icons.money_off),
                  Text(
                    "Skipped $category from ${formatDuration(start)} to ${formatDuration(end)}",
                  )
                ],
              )
            ),
          );
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _positionSubscription?.cancel();
    ApiService.setVideoProgress(
        widget.youtubeId, _lastReportedPosition.inSeconds);
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleVideoPlayer(
      player: _player,
      videoCreator: widget.videoCreator,
      videoTitle: widget.videoTitle,
    );
  }
}
