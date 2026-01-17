import 'dart:async';
import 'dart:io';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/features/player/domain/video_player_interface.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class GestureControlsOverlay extends StatefulWidget {
  final MediaPlayer player;
  final bool fullscreen;
  final void Function(String message, IconData icon) onShowMessage;
  final VoidCallback? onOpenFullscreen;

  const GestureControlsOverlay({
    super.key,
    required this.player,
    required this.fullscreen,
    required this.onShowMessage,
    this.onOpenFullscreen,
  });

  @override
  State<GestureControlsOverlay> createState() => _GestureControlsOverlayState();
}

class _GestureControlsOverlayState extends State<GestureControlsOverlay> {
  double _dragAccumulator = 0;
  int _pendingSkipSeconds = 0;
  Timer? _skipTimer;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Positioned.fill(
      child: Row(
        children: [
          // Left zone
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) async {
                if (SettingsService.vpGestureSwipe!=false && widget.fullscreen == true && Platform.isAndroid) {
                  _dragAccumulator += details.delta.dy;
                  double brightness = await DeviceService.getBrightness() ?? 0.0;
                  if (_dragAccumulator <= -10) {
                    brightness = (brightness + 0.05).clamp(0.0, 1.0);
                    DeviceService.setBrightness(brightness);
                    widget.onShowMessage("${localizations.playerBrightness} ${(brightness * 100).round()}%", Icons.brightness_5_rounded);
                    _dragAccumulator = 0;
                  } else if (_dragAccumulator >= 10) {
                    brightness = (brightness - 0.05).clamp(0.0, 1.0);
                    DeviceService.setBrightness(brightness);
                    widget.onShowMessage("${localizations.playerBrightness} ${(brightness * 100).round()}%", Icons.brightness_5_rounded);
                    _dragAccumulator = 0;
                  }
                }
              },
              onDoubleTap: () {
                if (SettingsService.vpGestureDoubleTap!=false) {
                  _pendingSkipSeconds += 10;
                  widget.onShowMessage(
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
          // Center zone
          Expanded(
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (SettingsService.vpGestureFullscreen!=false) {
                  if (details.primaryVelocity != null && details.primaryVelocity! > 0 && widget.fullscreen == true) {
                    widget.onShowMessage(localizations.playerMinimize, Icons.fullscreen_exit_rounded);
                    Navigator.of(context).pop();
                  } else if (details.primaryVelocity != null && details.primaryVelocity! < 0 && widget.fullscreen != true) {
                    widget.onShowMessage(localizations.playerMaximize, Icons.fullscreen_rounded);
                    widget.onOpenFullscreen?.call();
                  }
                }
              },
              onDoubleTap: () {
                if (SettingsService.vpGestureDoubleTap!=false) {
                  if (widget.player.isPlaying) {
                      widget.player.pause();
                      widget.onShowMessage(localizations.playerPaused, Icons.pause);
                    } else {
                      widget.player.play();
                      widget.onShowMessage(localizations.playerPlay, Icons.play_arrow);
                    }
                  }
                },
              child: Container(color: Colors.transparent),
            ),
          ),
          // Right zone
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) async {
                if (SettingsService.vpGestureSwipe!=false && widget.fullscreen == true) {
                  _dragAccumulator += details.delta.dy;
                  if (_dragAccumulator <= -10) {
                    double current = await DeviceService.getVolume() ?? 0.0;
                    DeviceService.setVolume((current + 0.05).clamp(0.0, 1.0));
                    widget.onShowMessage("${localizations.playerVolume} ${(current + 0.05).clamp(0.0, 1.0) * 100 ~/ 1}%", Icons.volume_up_rounded);
                    _dragAccumulator = 0;
                  } else if (_dragAccumulator >= 10) {
                    double current = await DeviceService.getVolume() ?? 0.0;
                    DeviceService.setVolume((current - 0.05).clamp(0.0, 1.0));
                    widget.onShowMessage("${localizations.playerVolume} ${(current + 0.05).clamp(0.0, 1.0) * 100 ~/ 1}%", Icons.volume_down_rounded);
                    _dragAccumulator = 0;
                  }
                }
              },
              onDoubleTap: () {
                if (SettingsService.vpGestureDoubleTap!=false) {
                  _pendingSkipSeconds += 10;
                  widget.onShowMessage("${localizations.playerForward} $_pendingSkipSeconds ${localizations.playerSeconds}", Icons.fast_forward_rounded);
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
    );
  }
}