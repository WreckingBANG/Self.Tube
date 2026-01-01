import 'package:flutter/material.dart';
import 'package:Self.Tube/widgets/media/video/video_player_interface.dart';
import 'package:Self.Tube/widgets/sheets/video_player_bottomsheet.dart';

class TopControlsOverlay extends StatefulWidget {
  final MediaPlayer player;
  final String videoTitle;
  final String videoCreator;

  const TopControlsOverlay({
    super.key,
    required this.player,
    required this.videoCreator,
    required this.videoTitle
  });

  @override
  State<TopControlsOverlay> createState() => _TopControlsOverlayState();
}

class _TopControlsOverlayState extends State<TopControlsOverlay> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
            padding: EdgeInsets.only(left: 12, right: 12, top: 30), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.videoTitle,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(widget.videoCreator),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showVideoPlayerBottomSheet(context: context, player: widget.player);
                  },
                  icon: Icon(Icons.settings_outlined)
                )
              ],
            )
          )
        ],
      ),
    );
  }
}