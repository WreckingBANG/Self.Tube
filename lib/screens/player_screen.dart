import 'package:Self.Tube/screens/channelpage_screen.dart';
import 'package:Self.Tube/widgets/sections/video_list_similar_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/widgets/containers/selectable_text.dart';
import '../utils/number_formatter.dart';
import '../utils/datetime_formatter.dart';
import '../widgets/sections/comment_list_section.dart';
import '../services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/settings_service.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/media/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final String youtubeId;

  const PlayerScreen({
    Key? key,
    required this.youtubeId,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(localizations.playerTitle)),
        body: FutureBuilder(
          future: ApiService.fetchVideoPlayer(widget.youtubeId),
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
                                child: CachedNetworkImage(
                                  imageUrl: "$baseUrl/${video.channelThumbUrl}",
                                  httpHeaders: {
                                    'Authorization': 'token $apiToken',
                                  },
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChannelpageScreen(
                                    channelId: video.channelId,
                                  ),
                                ),
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
