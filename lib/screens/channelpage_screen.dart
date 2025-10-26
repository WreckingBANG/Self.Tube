import 'package:Self.Tube/widgets/video_list_section.dart';
import 'package:flutter/material.dart';

class ChannelpageScreen extends StatelessWidget{
  final String channelId;

  const ChannelpageScreen({
    Key? key,
    required this.channelId,
  }) : super(key: key);


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Channel"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VideoListSection(title: "Videos", query: "?channel=${channelId}&order=desc&sort=published&type=videos")
          ],
        ),
      )
    );
  }
}

