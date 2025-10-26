import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../services/api_service.dart';
import '../screens/channelpage_screen.dart';
import '../screens/playlistpage_screen.dart';
import '../services/settings_service.dart';

class PlaylistListTile extends StatelessWidget {
  final dynamic playlist;

  const PlaylistListTile({super.key, required this.playlist});

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(playlist.playlistName),
        subtitle: Text(playlist.playlistChannelName),
        leading: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CachedNetworkImage(
                imageUrl: "$baseUrl/${playlist.playlistPic}",
                httpHeaders: {
                  'Authorization': 'token $apiToken',
                },
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaylistpageScreen(playlistId: playlist.playlistId)),
          );
        },
        onLongPress: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 470,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: 
                  Column(
                    children: [
                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainerLowest,
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Local Actions"),
                            ListTile(
                              leading: Icon(Icons.timer_outlined),
                              title: Text("Mark as Watched"),
                              onTap: () {
                                ApiService.setVideoWatched(playlist.youtubeId, true);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.timer_off_outlined),
                              title: Text("Mark as Unwatched"),
                              onTap: () {
                                ApiService.setVideoWatched(playlist.youtubeId, false);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.person_2_rounded),
                              title: Text("Open Channel"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: playlist.playlistChannelId)),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text("Share"),
                              onTap: () {
                                SharePlus.instance.share(
                                  ShareParams(uri: Uri.parse("https://www.youtube.com/watch?v=${playlist.playlistId}"))
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.file_download_outlined),
                              title: Text("Download Locally"),
                              subtitle: Text("Coming Soon"),
                              onTap: () {},
                            ),
                          ]
                        ),
                      ),
                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainerLowest,
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Server Actions"),
                            ListTile(
                              leading: Icon(Icons.cloud_download),
                              title: Text("Redownload to Server"),
                              subtitle: Text("Coming Soon"),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: Icon(Icons.cloud_off_rounded),
                              title: Text("Delete Video from Server"),
                              subtitle: Text("Coming Soon"),
                              onTap: () {},
                            ),
                          ]
                        ),
                      ),
                    ],
                  )
                )
              );
            },
          );
        },
      ),
    );
  }
}

