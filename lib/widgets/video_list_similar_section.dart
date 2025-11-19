import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/videolist_similar_model.dart';
import 'video_list_tile.dart';
import '../l10n/generated/app_localizations.dart';

class VideoListSimilarSection extends StatelessWidget {
  final String videoId;
  final String query;

  const VideoListSimilarSection({
    super.key,
    required this.videoId,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return FutureBuilder<List<VideoListSimilarItemModel>?>(
      future: ApiService.fetchSimilarVideoList(videoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(localizations.errorFailedToLoadData));
        } else if (!snapshot.hasData) {
          return Center(child: Text(localizations.errorNoDataFound));
        } else {
          final videos = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: videos
              .map((video) => VideoListTile(video: video, hideChannel: false))
              .toList(),
          );
        }
      },
    );
  }
}
