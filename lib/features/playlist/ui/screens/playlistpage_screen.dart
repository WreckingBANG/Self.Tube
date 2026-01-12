import 'package:flutter/material.dart';
import 'package:Self.Tube/ui/widgets/sections/video_list_section.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/ui/widgets/containers/refresh_container.dart';

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
      body: RefreshContainer(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            VideoListSection(title: localizations.playlistVideos, query: "?playlist=${playlistId}", showSorting: true, hideChannel: false,)
          ] 
        )
      )
    );
  }
}

