import 'package:Self.Tube/widgets/video_list_section.dart';
import 'package:flutter/material.dart';

class PlaylistpageScreen extends StatelessWidget{
  final String playlistId;

  const PlaylistpageScreen({
    Key? key,
    required this.playlistId,
  }) : super(key: key);


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Playlist"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VideoListSection(title: "Videos", query: "?playlist=${playlistId}")
          ],
        ),
      )
    );
  }
}

