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
          children: 
            List.generate(videos.length, (index) {
                final video = videos[index];

                final shape = RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: index == 0
                        ? const Radius.circular(12)
                        : const Radius.circular(4),
                    bottom: index == videos.length - 1
                        ? const Radius.circular(12)
                        : const Radius.circular(4),
                  ),
                );

                return Card(
                  shape: shape,
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                  child: VideoListTile(
                    video: video,
                    hideChannel: false,
                  ),
                );
              }
            )
          );
        }
      },
    );
  }
}
