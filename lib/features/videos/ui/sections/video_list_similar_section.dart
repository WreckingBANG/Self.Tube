import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/videos/ui/tiles/video_list_tile.dart';
import 'package:Self.Tube/features/player/data/api/player_api.dart';
import 'package:Self.Tube/features/videos/data/models/videolist_similar_model.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

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
