import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../services/api_service.dart';
import '../screens/channelpage_screen.dart';
import '../screens/playlistpage_screen.dart';
import '../services/settings_service.dart';
import '../l10n/generated/app_localizations.dart';

class PlaylistListTile extends StatelessWidget {
  final dynamic playlist;

  const PlaylistListTile({super.key, required this.playlist});

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                            Text(localizations.sheetLocalActions,),
                            ListTile(
                              leading: Icon(Icons.timer_outlined),
                              title: Text(localizations.sheetMarkWatched),
                              onTap: () {
                                ApiService.setVideoWatched(playlist.youtubeId, true);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.timer_off_outlined),
                              title: Text(localizations.sheetMarkUnwatched),
                              onTap: () {
                                ApiService.setVideoWatched(playlist.youtubeId, false);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.person_2_rounded),
                              title: Text(localizations.sheetOpenChannel),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: playlist.channelId)),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text(localizations.sheetShare),
                              onTap: () {
                                SharePlus.instance.share(
                                  ShareParams(uri: Uri.parse("https://www.youtube.com/watch?v=${playlist.youtubeId}"))
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.file_download_outlined),
                              title: Text(localizations.sheetDownloadLocal),
                              subtitle: Text(localizations.sheetComingSoon),
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
                            Text(localizations.sheetServerActions),
                            ListTile(
                              leading: Icon(Icons.cloud_download),
                              title: Text(localizations.sheetRedownloadServer),
                              subtitle: Text(localizations.sheetComingSoon),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: Icon(Icons.cloud_off_rounded),
                              title: Text(localizations.sheetDeleteVideoServer),
                              subtitle: Text(localizations.sheetComingSoon),
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

