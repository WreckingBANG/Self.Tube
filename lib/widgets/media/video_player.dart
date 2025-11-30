import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:Self.Tube/widgets/media/video_player_interface.dart';
import 'package:Self.Tube/widgets/media/video_player_factory.dart';
import 'package:Self.Tube/services/api_service.dart';
import 'package:Self.Tube/services/settings_service.dart';
import 'package:Self.Tube/utils/duration_formatter.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'video_player_ui.dart';


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

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    // Create the correct adapter via factory (video_player or mediakit)
    _player = MediaPlayerFactory.create(
      '$baseUrl${widget.videoUrl}',
      headers: {
        'Authorization': 'token $apiToken',
      },
    );

    bool _resumeApplied = false;

    _positionSubscription = _player.positionStream.listen((position) {
      final seconds = position.inSeconds;

      // Resume from saved position
      if (!_resumeApplied &&
          widget.videoPosition > 0 &&
          _lastReportedPosition == Duration.zero &&
          seconds > 0) {
        _player.seek(Duration(seconds: widget.videoPosition.toInt()));
        _resumeApplied = true;
        return;
      }

      // Report progress...
      if ((seconds - _lastReportedPosition.inSeconds).abs() >= 10) {
        _lastReportedPosition = position;
        ApiService.setVideoProgress(widget.youtubeId, seconds);
      }

      // SponsorBlock skipping
      if (_resumeApplied && SettingsService.sponsorBlockEnabled == true) {
        for (final segment in widget.sponsorSegments ?? []) {
          final start = segment.segment[0].round();
          final end = segment.segment[1].round();
          final category = segment.category.toLowerCase();

          final categoryEnabledMap = {
            'sponsor': SettingsService.sbSponsor,
            'selfpromo': SettingsService.sbSelfpromo,
            'interaction': SettingsService.sbInteraction,
            'intro': SettingsService.sbIntro,
            'outro': SettingsService.sbOutro,
            'preview': SettingsService.sbPreview,
            'hook': SettingsService.sbHook,
            'filler': SettingsService.sbFiller,
          };

          if (categoryEnabledMap[category] == true &&
              seconds >= start &&
              seconds < end) {
            _player.seek(Duration(seconds: end));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.playerSBSkipped(
                    category,
                    formatDuration(start),
                    formatDuration(end),
                  ),
                ),
              ),
            );
            break;
          }
        }
      }
    });
    _player.play();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    WakelockPlus.disable();
    ApiService.setVideoProgress(
        widget.youtubeId, _lastReportedPosition.inSeconds);
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Unified UI widget that works with either adapter
    return SimpleVideoPlayer(
      player: _player,
      videoCreator: widget.videoCreator,
      videoTitle: widget.videoTitle,
    );
  }
}
