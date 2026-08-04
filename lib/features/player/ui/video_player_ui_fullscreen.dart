import 'dart:async';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/features/player/domain/video_player_interface.dart';
import 'package:Self.Tube/features/player/ui/overlays/fastforward_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'overlays/bottom_controls_overlay.dart';
import 'overlays/top_controls_overlay.dart';
import 'overlays/gesture_message.dart';
import 'overlays/gesture_controls_overlay.dart';
import 'overlays/center_controls_overlay.dart';

class VideoPlayerFullscreenUI extends StatefulWidget {
  final MediaPlayer player;
  final String videoTitle;
  final String videoCreator;
  const VideoPlayerFullscreenUI({
    super.key,
    required this.player,
    required this.videoTitle,
    required this.videoCreator
  });

  @override
  State<VideoPlayerFullscreenUI> createState() => _VideoPlayerFullscreenUIState();
}

class _VideoPlayerFullscreenUIState extends State<VideoPlayerFullscreenUI> {
  bool _showControls = false;
  bool _showFF = false;
  Timer? _hideTimer;
  String? _gestureMessage;
  IconData? _gestureIcon;
  Timer? _messageTimer;

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
    DeviceService.setFullScreen(true);
    final size = widget.player.size;
  
    if (size.width > size.height) {
      DeviceService.setOrientation([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      DeviceService.setOrientation([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _toggleControls() {
    if (_showControls) {
      _hideTimer?.cancel();
      setState(() => _showControls = false);
      DeviceService.showSystemUI(true);
    } else {
      setState(() => _showControls = true);
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showControls = false);
          DeviceService.showSystemUI(true);
        }
      });
      DeviceService.showSystemUI(false);
    }
  }

  //this is duplicated code from video_player_ui, make sure to change that when changing this
  void _toggleFastForward(bool toggle) {
    //TODO: add settings toggle
    PlaybackSpeed playbackSpeed;
    if (toggle) {
      //this is to emulate youtube behaviour with vibration
      HapticFeedback.heavyImpact();
      if (!widget.player.isPlaying) return;
      setState(() => _showFF = true);
      playbackSpeed = PlaybackSpeed.x2_0;
    } else {
      if (!widget.player.isPlaying) return;
      setState(() => _showFF = false);
      playbackSpeed = PlaybackSpeed.x1_0;
    }
    widget.player.setPlaybackSpeed(playbackSpeed);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    DeviceService.setFullScreen(false);
    DeviceService.setOrientation(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        onLongPress: () => _toggleFastForward(true),
        onLongPressEnd: (details) => _toggleFastForward(false),
        child: Stack(
          children: [
            Center(child: widget.player.buildView()),
            Stack(
              children: [
                GestureControlsOverlay(player: widget.player, fullscreen: true, onShowMessage: _showMessage),
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
                      TopControlsOverlay(player: widget.player, videoCreator: widget.videoCreator, videoTitle: widget.videoTitle),
                      // Center
                      CenterControlsOverlay(player: widget.player),
                      // Bottom controls
                      BottomControlsOverlay(player: widget.player, fullscreen: true)
                    ],
                  ),
                ],
                if (_showFF) FastforwardOverlay(playbackSpeedText: "2x"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
