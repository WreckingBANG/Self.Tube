import 'package:flutter/material.dart';
import 'package:Self.Tube/ui/screens/channelpage_screen.dart';
import 'package:Self.Tube/ui/widgets/media/images/custom_network_image.dart';
import 'package:Self.Tube/ui/screens/player_screen.dart';
import 'package:Self.Tube/data/services/settings_service.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/ui/utils/duration_formatter.dart';
import 'package:Self.Tube/ui/utils/number_formatter.dart';
import 'package:Self.Tube/ui/utils/timeago_formatter.dart';
import 'package:Self.Tube/ui/widgets/sheets/video_list_bottomsheet.dart';

class VideoListTile extends StatelessWidget {
  final dynamic video;
  final bool hideChannel;

  const VideoListTile({super.key, required this.video,required this.hideChannel});

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

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
                      CustomNetwokImage(imageLink: video.thumbnail),
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
                                      CustomNetwokImage(imageLink: video.channelThumb)
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
          showVideoListBottomSheet(
            context: context,
            video: video, 
            hideChannel: hideChannel
          );
        },
      ),
    );
  }
}

