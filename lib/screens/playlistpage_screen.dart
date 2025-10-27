import 'package:Self.Tube/widgets/video_list_section.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

class PlaylistpageScreen extends StatelessWidget{
  final String playlistId;

  const PlaylistpageScreen({
    Key? key,
    required this.playlistId,
  }) : super(key: key);


  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.playlistTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VideoListSection(title: localizations.playlistVideos, query: "?playlist=${playlistId}")
          ],
        ),
      )
    );
  }
}

