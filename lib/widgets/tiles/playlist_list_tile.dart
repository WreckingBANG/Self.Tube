import 'package:Self.Tube/widgets/sheets/playlist_list_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/widgets/media/images/custom_network_image.dart';
import '../../screens/channelpage_screen.dart';
import '../../screens/playlistpage_screen.dart';
import '../../services/settings_service.dart';

class PlaylistListTile extends StatelessWidget {
  final dynamic playlist;

  const PlaylistListTile({super.key, required this.playlist});

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

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

