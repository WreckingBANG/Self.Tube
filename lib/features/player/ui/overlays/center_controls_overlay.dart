import 'package:Self.Tube/features/player/domain/video_player_interface.dart';
import 'package:flutter/material.dart';

class CenterControlsOverlay extends StatefulWidget {
  final MediaPlayer player;

  const CenterControlsOverlay({
    super.key,
    required this.player,
  });

  @override
  State<CenterControlsOverlay> createState() => _CenterControlsOverlayState();
}

class _CenterControlsOverlayState extends State<CenterControlsOverlay> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ), 
          ),
          Align(
            alignment: Alignment.center,
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
                        ? Icons.pause
                        : Icons.play_arrow,
                    ),
                    onPressed: () {
                      isP
                        ? widget.player.pause()
                        : widget.player.play();
                    },
                );
              }
            )
          )
        ],
      )
    ); 
  }
}