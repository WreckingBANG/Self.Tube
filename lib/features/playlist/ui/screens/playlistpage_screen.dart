import 'package:Self.Tube/common/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class PlaylistpageScreen extends StatefulWidget{
  final String playlistId;

  const PlaylistpageScreen({
    super.key,
    required this.playlistId
  });

  @override
  State<PlaylistpageScreen> createState() => _PlaylistpageScreenState();
}

class _PlaylistpageScreenState extends State<PlaylistpageScreen> {

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.playlistTitle),
      ),
      body: RefreshContainer(
        child: FutureBuilder(
          future: PlaylistApi().fetchPlaylist(widget.playlistId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(localizations.errorFailedToLoadData));
            } else if (!snapshot.hasData) {
              return Center(child: Text(localizations.errorNoDataFound));
            } else {
              final playlist = snapshot.data!;
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(playlist.playlistName),
                    leading: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomNetwokImage(imageLink: playlist.playlistPic)
                      ),
                    ),
                    trailing: playlist.playlistType == "regular"
                      ? playlist.playlistSubscribed
                          ? FilledButton(
                              onPressed: () {
                                ConfirmationDialog(
                                  context: context, 
                                  onSure: () {
                                    PlaylistApi.modifyRegularPlaylistState(playlist.playlistId, false);
                                  }
                                ); 
                              },
                              child: Text(localizations.playerUnsubscribe),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                PlaylistApi.modifyRegularPlaylistState(playlist.playlistId, true);
                              },
                              child: Text(localizations.playerSubscribe),
                            )
                      : null
                  ),
                  SizedBox(height: 20),
                  VideoListSection(
                    title: localizations.playlistVideos, 
                    query: "?playlist=${widget.playlistId}", 
                    showSorting: false,
                    hideChannel: false, 
                    playlistId: widget.playlistId,
                    playlistType: playlist.playlistType,
                  ),
                ] 
              );
            }
          }
        )
      )
    );
  }
}

