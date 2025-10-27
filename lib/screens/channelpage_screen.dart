import 'package:Self.Tube/widgets/video_list_section.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';


class ChannelpageScreen extends StatelessWidget{
  final String channelId;

  const ChannelpageScreen({
    Key? key,
    required this.channelId,
  }) : super(key: key);


  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.channelTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VideoListSection(title: localizations.channelVideos, query: "?channel=${channelId}&order=desc&sort=published&type=videos")
          ],
        ),
      )
    );
  }
}

