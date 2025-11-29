import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:Self.Tube/utils/duration_formatter.dart';
import 'package:Self.Tube/widgets/media/video_player_ui_landscape.dart';
import 'package:Self.Tube/widgets/media/gesture_message.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final Player player;
  final videoTitle;
  final videoCreator;
  const SimpleVideoPlayer({
    Key? key, 
    required this.player,
    required this.videoTitle,
    required this.videoCreator
  }) : super(key: key);

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  late final VolumeController _volumeController;
  late final VideoController _controller;
  String? _gestureMessage;
  IconData? _gestureIcon;
  Timer? _messageTimer;
  bool _showControls = false;
  Timer? _timer;
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
      if (mounted) {
        setState(() {
          _gestureMessage = null;
          _gestureIcon = null;
        });
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
    _controller = VideoController(widget.player);
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
        builder: (_) => FullscreenVideo(player: widget.player, videoCreator: widget.videoCreator, videoTitle: widget.videoTitle,),
      ),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        child: Stack(
          children: [
            Center(
              child: Video(
                controller: _controller,
                controls: null,
              ),
            ),
            Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    children: [
                      // Left zone (seek back)
                      Expanded(
                        child: GestureDetector(
                          onDoubleTap: () {
                            _pendingSkipSeconds += 10;
                            _showMessage("${localizations.playerRewind} $_pendingSkipSeconds ${localizations.playerSeconds}", Icons.fast_rewind_rounded);
                            _skipTimer?.cancel();
                            _skipTimer = Timer(const Duration(milliseconds: 400), () {
                              final newPos = widget.player.state.position - Duration(seconds: _pendingSkipSeconds);
                              final duration = widget.player.state.duration;
                              widget.player.seek(
                                newPos <= duration ? newPos : duration,
                              );
                              _pendingSkipSeconds = 0;
                            });
                          },
                          child: Container(color: Colors.transparent), // invisible hitbox
                        ),
                      ),

                      // Center zone (play/pause)
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragEnd: (details) {
                                if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
                                  _showMessage(localizations.playerMaximize, Icons.fullscreen_rounded);
                                  _openFullscreen();
                                }
                          },
                          onDoubleTap: () {
                            if (widget.player.state.playing) {
                                widget.player.pause();
                                _showMessage(localizations.playerPaused, Icons.pause);
                              } else {
                                widget.player.play();
                                _showMessage(localizations.playerPlay, Icons.play_arrow);
                              }
                          },
                          child: Container(color: Colors.transparent),
                        ),
                      ),

                      // Right zone (seek forward)
                      Expanded(
                        child: GestureDetector(
                          onDoubleTap: () {
                            _pendingSkipSeconds += 10;
                            _showMessage("${localizations.playerForward} $_pendingSkipSeconds ${localizations.playerSeconds}", Icons.fast_forward_rounded);
                            _skipTimer?.cancel();
                            _skipTimer = Timer(const Duration(milliseconds: 400), () {
                              final newPos = widget.player.state.position + Duration(seconds: _pendingSkipSeconds);
                              final duration = widget.player.state.duration;
                              widget.player.seek(
                                newPos <= duration ? newPos : duration,
                              );
                              _pendingSkipSeconds = 0;
                            });
                          },
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_gestureMessage != null && _gestureIcon != null) ...[
                  GestureMessage(
                    message: _gestureMessage!,
                    icon: _gestureIcon!,
                  ),
                ],
                if (_showControls) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Stack(
                      children: [
                        // Center play/pause button
                        Center(
                          child: IconButton(
                            color: Colors.white,
                            iconSize: 64,
                            icon: Icon(
                              widget.player.state.playing
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                            ),
                            onPressed: () {
                              widget.player.state.playing
                                  ? widget.player.pause()
                                  : widget.player.play();
                            },
                          ),
                        ),

                        // Bottom controls
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDuration(widget.player.state.position.inSeconds),
                                  ),
                                  Text(
                                    formatDuration(widget.player.state.duration.inSeconds),
                                  ),
                                ],
                              ),
                              Slider(
                                min: 0,
                                max: widget.player.state.duration.inSeconds.toDouble(),
                                value: widget.player.state.position.inSeconds
                                    .toDouble()
                                    .clamp(0, widget.player.state.duration.inSeconds.toDouble()),
                                onChanged: (value) {
                                  widget.player.seek(Duration(seconds: value.toInt()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ), 
                  )
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}