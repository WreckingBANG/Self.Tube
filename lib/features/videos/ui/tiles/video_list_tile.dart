import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/features/videos/ui/sheets/video_list_bottomsheet.dart';
import 'package:Self.Tube/common/utils/duration_formatter.dart';
import 'package:Self.Tube/common/utils/number_formatter.dart';
import 'package:Self.Tube/common/utils/timeago_formatter.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class VideoListTile extends StatelessWidget {
  final dynamic video;
  final bool hideChannel;

  const VideoListTile({super.key, required this.video,required this.hideChannel});

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
                          Navigator.pushNamed(
                            context, 
                            AppRouter.channelpageScreen,
                            arguments: video.channelId
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
          Navigator.pushNamed(
            context,
            AppRouter.player,
            arguments: video.youtubeId,
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

