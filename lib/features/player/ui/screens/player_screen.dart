import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/ui/widgets/containers/expandable_text.dart';
import 'package:Self.Tube/common/ui/widgets/containers/selectable_text.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/common/utils/datetime_formatter.dart';
import 'package:Self.Tube/common/utils/number_formatter.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:Self.Tube/features/videos/ui/sections/comment_list_section.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_similar_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class PlayerScreen extends StatefulWidget {
  final video;

  const PlayerScreen({
    super.key,
    required this.video,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  
  @override
  void initState() {
    super.initState();
    DeviceService.setWakeLock(true);
  }

  @override
  void dispose() {
    super.dispose();
    DeviceService.setWakeLock(false);
    DeviceService.resetBrightness(); 
  }
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_downward),
          ),
          title: Text(
            localizations.playerTitle
          )
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayerService.buildUI(
                          creator: widget.video.channelName,
                          title: widget.video.videoTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ExpandableText(
                      widget.video.videoTitle,
                      maxLines: 1,
                      textStyle: TextStyle(fontSize: 20),
                      showMoreText: false,
                    ), 
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("${formatNumberCompact(widget.video.videoViewCount, context)} ${localizations.playerViews}"),
                                const Text(" • "),
                                Text(formatDateTime(widget.video.videoDate, context)),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.thumb_up, size: 15),
                                const SizedBox(width: 5),
                                Text(formatNumberCompact(widget.video.videoLikeCount, context)),
                                const Text(" • "),
                                const Icon(Icons.thumb_down, size: 15),
                                const SizedBox(width: 5),
                                Text(formatNumberCompact(widget.video.videoDislikeCount, context)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(widget.video.channelName, style: TextStyle(fontSize: 16),),
                      subtitle: Text(formatNumberCompact(widget.video.channelSubCount, context)),
                      leading: SizedBox(
                        width: 45,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomNetworkImage(
                              imageLink: widget.video.channelThumbUrl,
                              logicalWidth: 45,
                            )
                          ),
                        )
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context, 
                          AppRouter.channelpageScreen,
                          arguments: widget.video.channelId
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TabBar(
                      labelStyle: TextStyle(fontSize: 12),
                      dividerColor: Colors.transparent,
                      tabs: [
                        SizedBox(
                          height: 45,
                          child: Tab(
                            icon: const Icon(Icons.description, size: 15),
                            text: localizations.playerDescription,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          child: Tab(
                            icon: const Icon(Icons.comment, size: 15),
                            text: localizations.playerComments
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          child: Tab(
                            icon: const Icon(Icons.video_collection, size: 15),
                            text: localizations.playerSimilar
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: SelectableLinkText(
                  text: widget.video.videoDescription,
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: CommentListWidget(videoId: widget.video.videoId),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: VideoListSimilarSection(
                  videoId: widget.video.videoId,
                  query: "",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
