import 'package:Self.Tube/screens/channelpage_screen.dart';
import 'package:Self.Tube/widgets/sections/video_list_similar_section.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../utils/number_formatter.dart';
import '../utils/datetime_formatter.dart';
import '../widgets/sections/comment_list_section.dart';
import '../services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../services/settings_service.dart';
import '../l10n/generated/app_localizations.dart';
import '../utils/duration_formatter.dart';


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
  late final Player _player;
  late final VideoController _videoController;
  Duration _lastReportedPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _videoController = VideoController(_player);

    _positionSubscription = _player.stream.position.listen((position) {
      final seconds = position.inSeconds;
      if ((seconds - _lastReportedPosition.inSeconds).abs() >= 10) {
        _lastReportedPosition = position;
        ApiService.setVideoProgress(widget.youtubeId, seconds);
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    ApiService.setVideoProgress(widget.youtubeId, _lastReportedPosition.inSeconds);
    _player.dispose();
    super.dispose();
  }


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
              _player.open(
                Media(
                  '$baseUrl${video.videoUrl}',
                  httpHeaders: {
                    'Authorization': 'token $apiToken',
                  },
                ),
              );
              _player.stream.duration.listen((duration) {
                if (video.videoPosition > 0) {
                  _player.seek(Duration(seconds: video.videoPosition.toInt()));
                }
              });

              final categoryEnabledMap = {
                'sponsor': SettingsService.sbSponsor,
                'selfpromo': SettingsService.sbSelfpromo,
                'interaction': SettingsService.sbInteraction,
                'intro': SettingsService.sbIntro,
                'outro': SettingsService.sbOutro,
                'preview': SettingsService.sbPreview,
                'hook': SettingsService.sbHook,
                'filler': SettingsService.sbFiller,
              };

              if (SettingsService.sponsorBlockEnabled == true) {
                _player.stream.position.listen((position) {
                  final currentSeconds = position.inSeconds.toDouble().round();

                  for (final segment in video.sponsorBlock?.segments ?? []) {
                    final start = segment.segment[0].round();
                    final end = segment.segment[1].round();
                    final category = segment.category.toLowerCase();

                    if (categoryEnabledMap[category] == true &&
                        currentSeconds >= start &&
                        currentSeconds < end) {
                      _player.seek(Duration(seconds: end));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Skipped ${segment.category} from ${formatDuration(start)} to ${formatDuration(end)}")),
                      );
                      break;
                    }
                  }
                });
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Video(controller: _videoController),
                      ),
                      const SizedBox(height: 12),
                      Text(video.videoTitle, style: const TextStyle(fontSize: 22)),
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
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
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
                            MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: video.channelId))
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TabBar(
                        tabs: <Widget>[
                          Tab(icon: const Icon(Icons.description), text: localizations.playerDescription),
                          Tab(icon: const Icon(Icons.comment), text: localizations.playerComments),
                          Tab(icon: const Icon(Icons.video_collection), text: localizations.playerSimilar),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(video.videoDescription),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommentListWidget(videoId: video.videoId),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      VideoListSimilarSection(videoId: widget.youtubeId, query: ""),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
