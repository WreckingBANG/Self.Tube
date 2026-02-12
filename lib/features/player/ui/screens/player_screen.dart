import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/ui/widgets/containers/selectable_text.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/common/utils/datetime_formatter.dart';
import 'package:Self.Tube/common/utils/number_formatter.dart';
import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
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
        appBar: AppBar(title: Text(localizations.playerTitle)),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayerService.buildUI(
                          creator: widget.video.channelName,
                          title: widget.video.videoTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(widget.video.videoTitle,style: const TextStyle(fontSize: 22)),
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
                                const Icon(Icons.thumb_up),
                                const SizedBox(width: 5),
                                Text(formatNumberCompact(widget.video.videoLikeCount, context)),
                                const Text(" • "),
                                const Icon(Icons.thumb_down),
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
                      title: Text(widget.video.channelName),
                      subtitle: Text(formatNumberCompact(widget.video.channelSubCount, context)),
                      leading: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomNetwokImage(imageLink: widget.video.channelThumbUrl)
                        ),
                      ),
                      trailing: widget.video.channelSubscribed
                          ? FilledButton(
                              onPressed: () {
                                ConfirmationDialog(
                                  context: context, 
                                  onSure: () {
                                    ChannelApi().modifyChannel(widget.video.channelId, false);
                                  }
                                );
                              },
                              child: Text(localizations.playerUnsubscribe),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                ChannelApi().modifyChannel(widget.video.channelId, true);
                              },
                              child: Text(localizations.playerSubscribe),
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
                      tabs: [
                        Tab(
                            icon: const Icon(Icons.description),
                            text: localizations.playerDescription),
                        Tab(
                            icon: const Icon(Icons.comment),
                            text: localizations.playerComments),
                        Tab(
                            icon: const Icon(Icons.video_collection),
                            text: localizations.playerSimilar),
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
