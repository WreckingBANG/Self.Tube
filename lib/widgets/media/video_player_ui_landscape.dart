import 'dart:async';
import 'package:media_kit/media_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:Self.Tube/utils/duration_formatter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:Self.Tube/widgets/media/gesture_message.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class FullscreenVideo extends StatefulWidget {
  final Player player;
  final String videoTitle;
  final String videoCreator;
  const FullscreenVideo({
    Key? key,
    required this.player,
    required this.videoTitle,
    required this.videoCreator
  }) : super(key: key);

  @override
  State<FullscreenVideo> createState() => _FullscreenVideoState();
}

class _FullscreenVideoState extends State<FullscreenVideo> {
  late final VolumeController _volumeController;
  late final VideoController _controller;
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
    _controller = VideoController(widget.player);
    _volumeController = VolumeController.instance;
    _volumeController.showSystemUI = false;
    _initBrightness();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });

    // Force landscape + hide system UI
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
    } else {
      setState(() => _showControls = true);
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showControls = false);
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _timer?.cancel();
    // Restore portrait + system UI
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
            Center(
              child: Video(
                controller: _controller,
                controls: null,
              ),
            ),
            Stack(
              children: [
                // Your video widget here
                Positioned.fill(
                  child: Row(
                    children: [
                      // Left zone (seek back)
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
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
                          },
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
                          child: Container(color: Colors.transparent),
                        ),
                      ),

                      // Center zone (play/pause)
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragEnd: (details) {
                            if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                              _showMessage(localizations.playerMinimize, Icons.fullscreen_exit_rounded);
                              Navigator.of(context).pop();
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
                          onVerticalDragUpdate: (details) async {
                            _dragAccumulator += details.delta.dy;

                            if (_dragAccumulator <= -10) {
                              // Finger moved up enough → increase volume
                              double current = await _volumeController.getVolume();
                              _volumeController.setVolume((current + 0.05).clamp(0.0, 1.0));
                              _showMessage("${localizations.playerVolume} ${(current + 0.05).clamp(0.0, 1.0) * 100 ~/ 1}%", Icons.volume_up_rounded);
                              _dragAccumulator = 0; // reset after applying
                            } else if (_dragAccumulator >= 10) {
                              // Finger moved down enough → decrease volume
                              double current = await _volumeController.getVolume();
                              _volumeController.setVolume((current - 0.05).clamp(0.0, 1.0));
                              _showMessage("${localizations.playerVolume} ${(current + 0.05).clamp(0.0, 1.0) * 100 ~/ 1}%", Icons.volume_down_rounded);
                              _dragAccumulator = 0;
                            }
                          },
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
                // Overlay your controls (play/pause button, slider, etc.)
                if (_showControls) ...[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.videoTitle,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(widget.videoCreator)
                            ],
                          ),
                        ),
                        // Center play/pause button
                        Center(
                          child: 
                            IconButton(
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
