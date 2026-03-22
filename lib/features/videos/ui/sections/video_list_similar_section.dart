import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/videos/domain/videolist_similar_provider.dart';
import 'package:Self.Tube/features/videos/ui/tiles/video_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListSimilarSection extends ConsumerWidget {
  final String videoId;
  final String query;

  const VideoListSimilarSection({
    super.key,
    required this.videoId,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final provider = ref.read(videoListSimilarProvider(videoId).notifier);
    final videos = ref.watch(videoListSimilarProvider(videoId));

    return videos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
      data: (videos) {
        return ListSectionContainer(
          itemCount: videos!.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return VideoListTile(
              video: video,
              hideChannel: false,
              onWatched: (value) => provider.setWatched(value, video.youtubeId),
              onDelete: () => provider.deleteVideo(video.youtubeId),
            );
          }
        );
      }
    );
  }
}
