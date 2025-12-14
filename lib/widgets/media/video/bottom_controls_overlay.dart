import 'package:flutter/material.dart';
import 'package:Self.Tube/widgets/media/video_player_interface.dart';
import 'package:Self.Tube/utils/duration_formatter.dart';

class BottomControlsOverlay extends StatefulWidget {
  final MediaPlayer player;
  final bool fullscreen;
  final VoidCallback? onOpenFullscreen;

  const BottomControlsOverlay({
    super.key,
    required this.player,
    required this.fullscreen,
    this.onOpenFullscreen
  });

  @override
  State<BottomControlsOverlay> createState() => _BottomControlsOverlayState();
}

class _BottomControlsOverlayState extends State<BottomControlsOverlay> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
          StreamBuilder<Duration>(
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
                        widget.fullscreen
                          ? IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                            )
                          : IconButton(
                              onPressed: widget.onOpenFullscreen,
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
        ],
      ),
    );
  }
}