import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:Self.Tube/services/api_service.dart';
import 'package:Self.Tube/services/settings_service.dart';
import 'package:Self.Tube/utils/duration_formatter.dart';
import 'video_player_ui.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class VideoPlayer extends StatefulWidget {
  final String videoTitle;
  final String videoCreator;
  final String youtubeId;
  final String videoUrl;
  final double videoPosition;
  final List<dynamic>? sponsorSegments;

  const VideoPlayer({
    Key? key,
    required this.videoTitle,
    required this.videoCreator,
    required this.youtubeId,
    required this.videoUrl,
    required this.videoPosition,
    this.sponsorSegments,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final Player _player;
  late final VideoController _videoController;
  Duration _lastReportedPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _videoController = VideoController(_player);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _player.open(
        Media(
          '$baseUrl${widget.videoUrl}',
          httpHeaders: {
            'Authorization': 'token $apiToken',
          },
        ),
      );
    });

    _positionSubscription = _player.stream.position.listen((position) {
      final seconds = position.inSeconds;

      if (widget.videoPosition > 0 &&
          _lastReportedPosition == Duration.zero &&
          seconds > 0) {
        _player.seek(Duration(seconds: widget.videoPosition.toInt()));
      }

      if ((seconds - _lastReportedPosition.inSeconds).abs() >= 10) {
        _lastReportedPosition = position;
        ApiService.setVideoProgress(widget.youtubeId, seconds);
      }

      if (SettingsService.sponsorBlockEnabled == true) {
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
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    ApiService.setVideoProgress(
        widget.youtubeId, _lastReportedPosition.inSeconds);
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleVideoPlayer(player: _player, videoCreator: widget.videoCreator, videoTitle: widget.videoTitle);
  }
}
