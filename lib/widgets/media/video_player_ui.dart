import 'dart:async';
import 'package:Self.Tube/utils/duration_formatter.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:Self.Tube/widgets/media/video_player_ui_landscape.dart';
import 'package:Self.Tube/widgets/media/gesture_message.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/media/video_player_interface.dart';
import 'package:Self.Tube/services/settings_service.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final MediaPlayer player;
  final String videoTitle;
  final String videoCreator;

  const SimpleVideoPlayer({
    super.key,
    required this.player,
    required this.videoTitle,
    required this.videoCreator,
  });

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  late final VolumeController _volumeController;

  String? _gestureMessage;
  IconData? _gestureIcon;
  Timer? _messageTimer;

  bool _showControls = false;
  Timer? _hideTimer;

  int _pendingSkipSeconds = 0;
  Timer? _skipTimer;

  void _showMessage(String message, IconData icon) {
    setState(() {
      _gestureMessage = message;
      _gestureIcon = icon;
    });

    _messageTimer?.cancel();
    _messageTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _gestureMessage = null;
        _gestureIcon = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
    _volumeController = VolumeController.instance;
    _volumeController.showSystemUI = true;
  }

  void _toggleControls() {
    if (_showControls) {
      _hideTimer?.cancel();
      setState(() => _showControls = false);
    } else {
      setState(() => _showControls = true);
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showControls = false);
      });
    }
  }

  void _openFullscreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullscreenVideo(
          player: widget.player,
          videoCreator: widget.videoCreator,
          videoTitle: widget.videoTitle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _messageTimer?.cancel();
    _skipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: Stack(
        children: [
          Center(child: widget.player.buildView()),
          // Gesture layers & controls
          Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    // Left zone
                    Expanded(
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (SettingsService.vpGestureDoubleTap!=false){
                            _pendingSkipSeconds += 10;
                            _showMessage(
                              "${localizations.playerRewind} $_pendingSkipSeconds ${localizations.playerSeconds}",
                              Icons.fast_rewind_rounded,
                            );
                            _skipTimer?.cancel();
                            _skipTimer = Timer(const Duration(milliseconds: 400), () {
                              final newPos = widget.player.position - Duration(seconds: _pendingSkipSeconds);
                              widget.player.seek(newPos >= Duration.zero ? newPos : Duration.zero);
                              _pendingSkipSeconds = 0;
                            });
                          }
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    // Center zone
                    Expanded(
                      child: GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (SettingsService.vpGestureFullscreen!=false){
                            if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
                              _showMessage(localizations.playerMaximize, Icons.fullscreen_rounded);
                              _openFullscreen();
                            }
                          }
                        },
                        onDoubleTap: () async {
                          if (SettingsService.vpGestureDoubleTap!=false){
                            if (widget.player.isPlaying) {
                              await widget.player.pause();
                              _showMessage(localizations.playerPaused, Icons.pause);
                            } else {
                              await widget.player.play();
                              _showMessage(localizations.playerPlay, Icons.play_arrow);
                            }
                          }
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    // Right zone
                    Expanded(
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (SettingsService.vpGestureDoubleTap!=false){
                            _pendingSkipSeconds += 10;
                            _showMessage(
                              "${localizations.playerForward} $_pendingSkipSeconds ${localizations.playerSeconds}",
                              Icons.fast_forward_rounded,
                            );
                            _skipTimer?.cancel();
                            _skipTimer = Timer(const Duration(milliseconds: 400), () {
                              final newPos = widget.player.position + Duration(seconds: _pendingSkipSeconds);
                              widget.player.seek(newPos <= widget.player.duration ? newPos : widget.player.duration);
                              _pendingSkipSeconds = 0;
                            });
                          }
                        },
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
              if (_gestureMessage != null && _gestureIcon != null)
                GestureMessage(
                  message: _gestureMessage!,
                  icon: _gestureIcon!,
                ),
              // Overlay controls
              if (_showControls)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Stack(
                    children: [
                      Center(
                        child: StreamBuilder(
                          stream: widget.player.playingStream,
                          initialData: widget.player.isPlaying, 
                          builder: (context, snapshot) {
                            final isP = snapshot.data ?? true;
                            return IconButton(
                                color: Colors.white,
                                iconSize: 64,
                                icon: Icon(
                                  isP
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                ),
                                onPressed: () {
                                  isP
                                    ? widget.player.pause()
                                    : widget.player.play();
                                },
                            );
                          }
                        )
                      ), 
                      // Bottom controls
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: StreamBuilder<Duration>(
                          stream: widget.player.positionStream,
                          initialData: widget.player.position,
                          builder: (context, snapshot) {
                            final pos = snapshot.data ?? Duration.zero;
                            return Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${formatDuration(pos.inSeconds)} • ${formatDuration(widget.player.duration.inSeconds)}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _openFullscreen();
                                        },
                                        icon: const Icon(Icons.fullscreen, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 10,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 6),
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max: widget.player.duration.inSeconds.toDouble(),
                                      value: pos.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        widget.player.seek(Duration(seconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
