import 'package:Self.Tube/core/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/features/channel/ui/screens/channelpage_screen.dart';
import 'package:Self.Tube/features/playlist/ui/screens/playlistpage_screen.dart';
import 'package:Self.Tube/features/playlist/ui/sheets/playlist_list_bottomsheet.dart';
import 'package:flutter/material.dart';

class PlaylistListTile extends StatelessWidget {
  final dynamic playlist;

  const PlaylistListTile({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),  
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 170,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CustomNetwokImage(imageLink: playlist.playlistPic)
                )   
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.playlistName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: playlist.playlistChannelId)),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            playlist.playlistChannelName,
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      )
                    )
                  ],
                ),
              )  
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaylistpageScreen(playlistId: playlist.playlistId)),
          );
        },
        onLongPress: () {
          showPlaylistListBottomSheet(
            context: context, 
            playlist: playlist
          );
        }
      ),
    );
  }
}

