import 'dart:async';
import 'package:Self.Tube/common/utils/duration_formatter.dart';
import 'package:Self.Tube/features/player/domain/sponsorblock_service.dart';
import 'package:Self.Tube/features/player/domain/video_player_interface.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:flutter/material.dart';

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
  bool scrubbing = false;
  final sliderController = StreamController<Duration>.broadcast();
  Duration sliderpos = Duration();
  
  @override
  void initState() {
    super.initState();
    sliderpos = widget.player.position;
    widget.player.positionStream.listen((pos) {
      if (!scrubbing) {
        sliderController.add(pos);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
          ),
          StreamBuilder<Duration>(
            stream: sliderController.stream,
            initialData: widget.player.position,
            builder: (context, snapshot) {
              final sliderValue = snapshot.data ?? Duration.zero;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 2.5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${formatDuration(sliderValue.inSeconds)} • ${formatDuration(widget.player.duration.inSeconds)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          widget.fullscreen
                            ? IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.transparent
                                ), 
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                              )
                            : IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.transparent
                                ), 
                                onPressed: widget.onOpenFullscreen,
                                icon: const Icon(Icons.fullscreen, color: Colors.white),
                              ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1.25),
                              child: CustomPaint(
                                size: Size(MediaQuery.of(context).size.width,10),
                                painter: SliderPainter(
                                  player: widget.player,
                                  context: context
                                ),
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                activeTrackColor: Colors.transparent,
                                inactiveTrackColor: Colors.transparent
                              ),
                              child: Slider(
                                padding: EdgeInsets.all(0),
                                min: 0,
                                max: widget.player.duration.inSeconds.toDouble(),
                                value: sliderValue.inSeconds.toDouble(),
                                onChanged: (value) {
                                  scrubbing = true;
                                  sliderController.add(Duration(seconds: value.toInt()));
                                },
                                onChangeEnd: (value) {
                                  scrubbing = false;
                                  widget.player.seek(Duration(seconds: value.toInt()));
                                },
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                )
              );
            }
          )
        ],
      ),
    );
  }
}

class SliderPainter extends CustomPainter{
  final MediaPlayer player;
  final BuildContext context;

  SliderPainter({
    required this.player,
    required this.context
  });

  @override
  void paint(Canvas canvas, Size size) {
    final videoLength = player.duration.inSeconds.toDouble();
    final videoPos = player.position.inSeconds.toDouble();
    final segments = SponsorblockService.processedSegments;
        
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0,0,size.width,10),
        Radius.circular(20)
      ),
      Paint()..color = Theme.of(context).colorScheme.surface
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0,0,size.width/videoLength*videoPos,10),
        Radius.circular(20)
      ),
      Paint()..color = Theme.of(context).colorScheme.primary
    );

    for (var segment in segments) {
      final start = size.width/videoLength*segment[1].toDouble();
      final end = size.width/videoLength*segment[2].toDouble()-start;
      Paint paint = Paint()..color = Colors.green; 

      switch (segment[0]) {
        case 'sponsor': paint = Paint()..color = Colors.green;
        case 'selfpromo': paint = Paint()..color = Colors.yellow;
        case 'interaction': paint = Paint()..color = Colors.pink;
        case 'intro': paint = Paint()..color = Colors.teal;
        case 'outro': paint = Paint()..color = Colors.blue;
        case 'preview': paint = Paint()..color = Colors.lightBlue;
        case 'hook': paint = Paint()..color = Colors.blueAccent;
        case 'filler': paint = Paint()..color = Colors.purple;
      }

      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(start,3,end,4),Radius.circular(20)), paint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}

