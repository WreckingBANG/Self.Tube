import 'package:Self.Tube/features/player/ui/screens/player_screen_large.dart';
import 'package:Self.Tube/features/player/ui/screens/player_screen_small.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget{
  final video;

  const PlayerScreen({
    super.key,
    required this.video
  });

  
  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        
        if (constraints.maxWidth > 1200) {
          return PlayerScreenLarge(video: video);
        } else {
          return PlayerScreenSmall(video: video);
        }
      }
    );
  }

}
