import 'package:Self.Tube/services/api/video_api.dart';
import 'package:flutter/material.dart';
import '../../models/video/videolist_similar_model.dart';
import '../tiles/video_list_tile.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';

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
      future: VideoApi().fetchSimilarVideoList(videoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(localizations.errorFailedToLoadData));
        } else if (!snapshot.hasData) {
          return Center(child: Text(localizations.errorNoDataFound));
        } else {
          final videos = snapshot.data!;
          return ListSectionContainer(
            children: [
              ...List.generate(videos.length, (index) {
                final video = videos[index];
                return VideoListTile(video: video, hideChannel: false);
              })
            ]
          );
        }
      },
    );
  }
}
