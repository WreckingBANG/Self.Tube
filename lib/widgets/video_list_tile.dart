import 'package:Self.Tube/screens/channelpage_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/player_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../services/api_service.dart';
import '../services/settings_service.dart';
import '../l10n/generated/app_localizations.dart';
import '../utils/duration_formatter.dart';
import '../utils/number_formatter.dart';
import '../utils/timeago_formatter.dart';

class VideoListTile extends StatelessWidget {
  final dynamic video;
  final bool hideChannel;

  const VideoListTile({super.key, required this.video,required this.hideChannel});

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            formatDuration(video.duration),
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
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
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${formatNumberCompact(video.views, context)} ${localizations.videoListViews} •  ${formatTimeAgo(context, video.videoDate)}",
                      style: TextStyle(fontSize: 13),
                    ),
                    if (!hideChannel)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: video.channelId)),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: "$baseUrl/${video.channelThumb}",
                                        httpHeaders: {
                                          'Authorization': 'token $apiToken',
                                        },
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ],
                                  ),
                                )   
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              video.channelName,
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
            MaterialPageRoute(builder: (context) => PlayerScreen(youtubeId: video.youtubeId)),
          );
        },
        onLongPress: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SizedBox(
                height: 570,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        localizations.sheetLocalActions,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            if (!hideChannel)
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
                      Text(
                        localizations.sheetServerActions,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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

