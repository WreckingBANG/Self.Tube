import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Self.Tube/widgets/media/video_player_interface.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:Self.Tube/utils/duration_formatter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:Self.Tube/widgets/media/gesture_message.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/services/settings_service.dart';

class FullscreenVideo extends StatefulWidget {
  final MediaPlayer player;
  final String videoTitle;
  final String videoCreator;
  const FullscreenVideo({
    super.key,
    required this.player,
    required this.videoTitle,
    required this.videoCreator
  });

  @override
  State<FullscreenVideo> createState() => _FullscreenVideoState();
}

class _FullscreenVideoState extends State<FullscreenVideo> {
  late final VolumeController _volumeController;
  bool _showControls = false;
  Timer? _timer;
  Timer? _hideTimer;
  double _dragAccumulator = 0;
  String? _gestureMessage;
  IconData? _gestureIcon;
  Timer? _messageTimer;
  double _currentBrightness = 0;
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

  Future<void> _initBrightness() async {
    final value = await ScreenBrightness.instance.system;
    if (mounted) {
      setState(() {
        _currentBrightness = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _volumeController = VolumeController.instance;
    _volumeController.showSystemUI = false;
    _initBrightness();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _toggleControls() {
    if (_showControls) {
      _hideTimer?.cancel();
      setState(() => _showControls = false);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      setState(() => _showControls = true);
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showControls = false);
          // Hide again when auto‑closing
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        }
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenBrightness.instance.setAutoReset(true);
    ScreenBrightness.instance.resetApplicationScreenBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        child: Stack(
          children: [
            Center(child: widget.player.buildView()),
            Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    children: [
                      // Left zone (seek back)
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (SettingsService.vpGestureSwipe!=false) {
                              _dragAccumulator += details.delta.dy;
                              if (_dragAccumulator <= -10) {
                                _currentBrightness = (_currentBrightness + 0.05).clamp(0.0, 1.0);
                                ScreenBrightness.instance.setApplicationScreenBrightness(_currentBrightness);
                                _showMessage("${localizations.playerBrightness} ${(_currentBrightness * 100).round()}%", Icons.brightness_5_rounded);
                                _dragAccumulator = 0;
                              } else if (_dragAccumulator >= 10) {
                                _currentBrightness = (_currentBrightness - 0.05).clamp(0.0, 1.0);
                                ScreenBrightness.instance.setApplicationScreenBrightness(_currentBrightness);
                                _showMessage("${localizations.playerBrightness} ${(_currentBrightness * 100).round()}%", Icons.brightness_5_rounded);
                                _dragAccumulator = 0;
                              }
                            }
                          },
                          onDoubleTap: () {
                            if (SettingsService.vpGestureDoubleTap!=false) {
                              _pendingSkipSeconds += 10;
                              _showMessage(
                                "${localizations.playerRewind} $_pendingSkipSeconds ${localizations.playerSeconds}",
                                Icons.fast_rewind_rounded,
                              );

                              _skipTimer?.cancel();
                              _skipTimer = Timer(const Duration(milliseconds: 400), () {
                                final newPos = widget.player.position -
                                    Duration(seconds: _pendingSkipSeconds);

                                widget.player.seek(
                                  newPos <= widget.player.duration ? newPos : widget.player.duration,
                                );

                                _pendingSkipSeconds = 0;
                              });
                            }
                          },
                          child: Container(color: Colors.transparent),
                        ),
                      ),

                      // Center zone (play/pause)
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragEnd: (details) {
                            if (SettingsService.vpGestureFullscreen!=false) {
                              if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                                _showMessage(localizations.playerMinimize, Icons.fullscreen_exit_rounded);
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          onDoubleTap: () {
                            if (SettingsService.vpGestureDoubleTap!=false) {
                              if (widget.player.isPlaying) {
                                  widget.player.pause();
                                  _showMessage(localizations.playerPaused, Icons.pause);
                                } else {
                                  widget.player.play();
                                  _showMessage(localizations.playerPlay, Icons.play_arrow);
                                }
                              }
                            },
                          child: Container(color: Colors.transparent),
                        ),
                      ),

                      // Right zone (seek forward)
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) async {
                            if (SettingsService.vpGestureSwipe!=false) {
                              _dragAccumulator += details.delta.dy;
                              if (_dragAccumulator <= -10) {
                                double current = await _volumeController.getVolume();
                                _volumeController.setVolume((current + 0.05).clamp(0.0, 1.0));
                                _showMessage("${localizations.playerVolume} ${(current + 0.05).clamp(0.0, 1.0) * 100 ~/ 1}%", Icons.volume_up_rounded);
                                _dragAccumulator = 0;
                              } else if (_dragAccumulator >= 10) {
                                double current = await _volumeController.getVolume();
                                _volumeController.setVolume((current - 0.05).clamp(0.0, 1.0));
                                _showMessage("${localizations.playerVolume} ${(current + 0.05).clamp(0.0, 1.0) * 100 ~/ 1}%", Icons.volume_down_rounded);
                                _dragAccumulator = 0;
                              }
                            }
                          },
                          onDoubleTap: () {
                            if (SettingsService.vpGestureDoubleTap!=false) {
                              _pendingSkipSeconds += 10;
                              _showMessage("${localizations.playerForward} $_pendingSkipSeconds ${localizations.playerSeconds}", Icons.fast_forward_rounded);
                              _skipTimer?.cancel();
                              _skipTimer = Timer(const Duration(milliseconds: 400), () {
                                final newPos = widget.player.position + Duration(seconds: _pendingSkipSeconds);
                                widget.player.seek(
                                  newPos <= widget.player.duration ? newPos : widget.player.duration,
                                );
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
                if (_gestureMessage != null && _gestureIcon != null) ...[
                  GestureMessage(
                    message: _gestureMessage!,
                    icon: _gestureIcon!,
                  ),
                ],
                // Overlay controls
                if (_showControls) ...[
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Stack(
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12, top: 30), 
                              child:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.videoTitle,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(widget.videoCreator)
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                      // Center
                      Center(
                        child: 
                          IconButton(
                            color: Colors.white,
                            iconSize: 64,
                            icon: Icon(
                              widget.player.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                            ),
                            onPressed: () {
                              widget.player.isPlaying
                                  ? widget.player.pause()
                                  : widget.player.play();
                            },
                        ),
                      ), 
                      // Bottom controls
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: [
                            Container(
                              height: 75,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.8),
                                  ],
                                ),
                              ),
                            ),
                            // Foreground controls
                            Padding(
                              padding: EdgeInsets.only(left: 12, right: 12, bottom: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${formatDuration(widget.player.position.inSeconds)} • ${formatDuration(widget.player.duration.inSeconds)}",
                                        style: TextStyle(color: Colors.white), // ensure visible
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.fullscreen_exit, color: Colors.white),
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
                                      value: widget.player.position.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        widget.player.seek(Duration(seconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}
