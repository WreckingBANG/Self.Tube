import 'package:Self.Tube/screens/channelpage_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/player_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../services/api_service.dart';
import '../services/settings_service.dart';
import '../l10n/generated/app_localizations.dart';

class VideoListTile extends StatelessWidget {
  final dynamic video;

  const VideoListTile({super.key, required this.video});

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(video.title),
        subtitle: Text(video.channelName),
        leading: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CachedNetworkImage(
                imageUrl: "$baseUrl/${video.thumbnail}",
                httpHeaders: {
                  'Authorization': 'token $apiToken',
                },
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              video.progress != 0 || video.watched == true
                ? LinearProgressIndicator(
                    value: video.progress != 0 ? video.progress / 100 : 1.0,
                    minHeight: 4,
                  )
                : SizedBox.shrink(),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlayerScreen(youtubeId: video.youtubeId)),
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
                                ApiService.setVideoWatched(video.youtubeId, true);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.timer_off_outlined),
                              title: Text(localizations.sheetMarkUnwatched),
                              onTap: () {
                                ApiService.setVideoWatched(video.youtubeId, false);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.person_2_rounded),
                              title: Text(localizations.sheetOpenChannel),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: video.channelId)),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text(localizations.sheetShare),
                              onTap: () {
                                SharePlus.instance.share(
                                  ShareParams(uri: Uri.parse("https://www.youtube.com/watch?v=${video.youtubeId}"))
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

