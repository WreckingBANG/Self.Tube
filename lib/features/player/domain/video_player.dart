import 'package:flutter/material.dart';
import 'dart:async';
import 'video_player_interface.dart';
import 'video_player_factory.dart';
import 'ui/video_player_ui.dart';
import 'package:Self.Tube/data/services/api/video_api.dart';
import 'package:Self.Tube/data/services/device_service.dart';
import 'package:Self.Tube/data/services/settings_service.dart';
import 'package:Self.Tube/ui/utils/duration_formatter.dart';
import 'package:Self.Tube/data/services/api/api_headers.dart';

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
