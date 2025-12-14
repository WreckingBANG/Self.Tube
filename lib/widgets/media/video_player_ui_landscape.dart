import 'dart:async';
import 'package:Self.Tube/widgets/media/video/bottom_controls_overlay.dart';
import 'package:Self.Tube/widgets/media/video/top_controls_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Self.Tube/widgets/media/video_player_interface.dart';
import 'package:Self.Tube/widgets/media/gesture_message.dart';
import 'video/gesture_controls_overlay.dart';
import 'video/center_controls_overlay.dart';

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
  bool _showControls = false;
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
