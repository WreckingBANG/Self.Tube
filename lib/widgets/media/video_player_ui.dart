import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Self.Tube/widgets/media/video_player_ui_landscape.dart';
import 'package:Self.Tube/widgets/media/gesture_message.dart';
import 'package:Self.Tube/widgets/media/video_player_interface.dart';
import './overlays/bottom_controls_overlay.dart';
import './overlays/gesture_controls_overlay.dart';
import './overlays/center_controls_overlay.dart';

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
  String? _gestureMessage;
  IconData? _gestureIcon;
  Timer? _messageTimer;

  bool _showControls = false;
  Timer? _hideTimer;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: Stack(
        children: [
          Center(child: widget.player.buildView()),
          // Gesture layers & controls
          Stack(
            children: [
              GestureControlsOverlay(player: widget.player, fullscreen: false, onShowMessage: _showMessage, onOpenFullscreen: _openFullscreen),
              if (_gestureMessage != null && _gestureIcon != null)
                GestureMessage(
                  message: _gestureMessage!,
                  icon: _gestureIcon!,
                ),
              // Overlay controls
              if (_showControls)
                Stack(
                  children: [
                    CenterControlsOverlay(player: widget.player),  
                    BottomControlsOverlay(
                      player: widget.player, 
                      fullscreen: false,
                      onOpenFullscreen: _openFullscreen,
                    )
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
