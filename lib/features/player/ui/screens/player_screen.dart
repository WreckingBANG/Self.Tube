import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/core/ui/widgets/containers/selectable_text.dart';
import 'package:Self.Tube/core/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/core/utils/datetime_formatter.dart';
import 'package:Self.Tube/core/utils/number_formatter.dart';
import 'package:Self.Tube/features/player/data/api/video_api.dart';
import 'package:Self.Tube/features/player/domain/video_player.dart';
import 'package:Self.Tube/features/player/ui/sections/comment_list_section.dart';
import 'package:Self.Tube/features/player/ui/sections/video_list_similar_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class PlayerScreen extends StatefulWidget {
  final String youtubeId;

  const PlayerScreen({
    super.key,
    required this.youtubeId,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(localizations.playerTitle)),
        body: FutureBuilder(
          future: VideoApi.fetchVideoPlayer(widget.youtubeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(localizations.errorFailedToLoadData));
            } else if (!snapshot.hasData) {
              return Center(child: Text(localizations.errorNoDataFound));
            } else {
              final video = snapshot.data!;
              return NestedScrollView(
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
                              child: CustomVideoPlayer(
                                youtubeId: video.videoId,
                                videoUrl: video.videoUrl,
                                videoPosition: video.videoPosition,
                                videoCreator: video.channelName,
                                videoTitle: video.videoTitle,
                                sponsorSegments: video.sponsorBlock?.segments,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(video.videoTitle,style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("${formatNumberCompact(video.videoViewCount, context)} ${localizations.playerViews}"),
                                      const Text(" • "),
                                      Text(formatDateTime(video.videoDate, context)),
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
                                      Text(formatNumberCompact(video.videoLikeCount, context)),
                                      const Text(" • "),
                                      const Icon(Icons.thumb_down),
                                      const SizedBox(width: 5),
                                      Text(formatNumberCompact(video.videoDislikeCount, context)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            title: Text(video.channelName),
                            subtitle: Text(formatNumberCompact(video.channelSubCount, context)),
                            leading: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomNetwokImage(imageLink: video.channelThumbUrl)
                              ),
                            ),
                            trailing: video.channelSubscribed
                                ? FilledButton(
                                    onPressed: () {},
                                    child: Text(localizations.playerUnsubscribe),
                                  )
                                : OutlinedButton(
                                    onPressed: () {},
                                    child: Text(localizations.playerSubscribe),
                                  ),
                            onTap: () {
                              Navigator.pushNamed(
                                context, 
                                AppRouter.channelpageScreen,
                                arguments: video.channelId
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
                        text: video.videoDescription,
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: CommentListWidget(videoId: video.videoId),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: VideoListSimilarSection(
                        videoId: widget.youtubeId,
                        query: "",
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
