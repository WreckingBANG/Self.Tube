import 'package:Self.Tube/screens/channelpage_screen.dart';
import 'package:Self.Tube/widgets/video_list_similar_section.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../utils/number_formatter.dart';
import '../utils/datetime_formatter.dart';
import '../widgets/comment_list_section.dart';
import '../services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../services/settings_service.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text("Player")),
        body: FutureBuilder(
          future: ApiService.fetchVideoPlayer(widget.youtubeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No video found"));
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

              // Wait until duration is available, then seek
              _player.stream.duration.listen((duration) {
                if (video.videoPosition > 0) {
                  _player.seek(Duration(seconds: video.videoPosition.toInt()));
                }
              });
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Video(controller: _videoController),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Text(video.videoTitle, style: const TextStyle(fontSize: 22)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("${formatNumberCompact(video.videoViewCount, context)} Views"),
                                      Text(" • "),
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
                                      Icon(Icons.thumb_up),
                                      SizedBox(width: 5),
                                      Text(formatNumberCompact(video.videoLikeCount, context)),
                                      Text(" • "),
                                      Icon(Icons.thumb_down),
                                      SizedBox(width: 5),
                                      Text(formatNumberCompact(video.videoDislikeCount, context)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
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
                                    child: Text('Unsubscribe'),
                                  )
                                : OutlinedButton(
                                    onPressed: () {},
                                    child: Text('Subscribe'),
                                  ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: video.channelId))
                              );
                            },
                          ),
                          const TabBar(
                            tabs: <Widget>[
                              Tab(
                                icon: Icon(Icons.description),
                                text: "Description"
                              ),
                              Tab(
                                icon: Icon(Icons.comment),
                                text: "Comments"
                              ),
                              Tab(
                                icon: Icon(Icons.video_collection),
                                text: "Similar Videos"
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              children: <Widget>[
                                Center(child: Text(video.videoDescription)),
                                Center(child: CommentListWidget(videoId: video.videoId)),
                                Center(child: VideoListSimilarSection(videoId: widget.youtubeId, query: "")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
