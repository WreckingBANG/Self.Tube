import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/sections/sort_chips_section.dart';
import 'package:Self.Tube/features/videos/domain/videolist_provider.dart';
import 'package:Self.Tube/features/videos/ui/tiles/video_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListSection extends ConsumerWidget {
  final String title;
  final bool hideChannel;
  final bool showSorting;
  final String query;
  final bool hideIfEmpty;
  final String playlistId;
  final String playlistType;

  VideoListSection({
    super.key,
    this.title = "",
    required this.hideChannel,
    required this.query,
    this.hideIfEmpty = false,
    this.playlistId = "",
    this.playlistType = "",
    this.showSorting = false,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final provider = ref.read(videoListProvider(query).notifier);
    final videos = ref.watch(videoListProvider(query));

    return videos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
      data: (videos) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (videos!.isNotEmpty || !hideIfEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
            if (showSorting)
              SortChipsSection(
                sortOptions: (value) {
                  provider.setSorting(value);
                },
              ),
            if (videos.isEmpty && hideIfEmpty)
              const SizedBox.shrink()
            else if (videos.isEmpty && !hideIfEmpty)
              Center(child: Text(localizations.errorNoDataFound))
            else
              ListSectionContainer(
                children: [
                  ...List.generate(videos.length, (index) {
                    final video = videos[index];
                    return VideoListTile(
                      video: video, 
                      hideChannel: hideChannel, 
                      playlistId: playlistId, 
                      playlistType: playlistType,
                      onWatched: (value) => provider.setWatched(value, video.youtubeId),
                      onDelete: () => provider.deleteVideo(video.youtubeId)
                    );
                  })
                ]
              ),
              
            if (provider.hasMore && videos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: provider.fetchNext,
                    child: Text(localizations.listShowMore),
                  ),
                ),
              ),
          ],
        );
      }
    );
  }
}
