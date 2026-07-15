import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/sections/empty_error_section.dart';
import 'package:Self.Tube/common/ui/widgets/sections/sort_chips_section.dart';
import 'package:Self.Tube/features/videos/domain/selection_provider.dart';
import 'package:Self.Tube/features/videos/domain/videolist_provider.dart';
import 'package:Self.Tube/features/videos/ui/containers/continue_watching_list.dart';
import 'package:Self.Tube/features/videos/ui/tiles/video_horizontal_tile.dart';
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
  final bool horizontalScroll;
  final String playlistId;
  final String playlistType;

  VideoListSection({
    super.key,
    this.title = "",
    required this.hideChannel,
    required this.query,
    this.horizontalScroll = false,
    this.hideIfEmpty = false,
    this.playlistId = "",
    this.playlistType = "",
    this.showSorting = false,
  });
  
  final OverlayPortalController _portalController = OverlayPortalController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final provider = ref.read(videoListProvider(query).notifier);
    final videos = ref.watch(videoListProvider(query));

    final select = ref.read(selectionProvider(query).notifier);
    final selection = ref.watch(selectionProvider(query));

    if (!_portalController.isShowing) {
      _portalController.show();
    }

    return videos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
      data: (videos) {

        return OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: (context) {
            if (selection.isEmpty) {
              return const SizedBox.shrink();
            } 
            
            return Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
                label: Text("Actions")
              )
            );

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((videos!.isNotEmpty || !hideIfEmpty) && !horizontalScroll)
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
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: EmptyErrorSection()
                )
              else if (horizontalScroll)
                ContinueWatchingList(
                  title: title,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return VideoHorizontalTile(
                      video: video, 
                      hideChannel: hideChannel, 
                      playlistId: playlistId, 
                      playlistType: playlistType,
                      onWatched: (value) => provider.setWatched(value, video.youtubeId),
                      onDelete: () => provider.deleteVideo(video.youtubeId)
                    );
                  },
                )
              else
                ListSectionContainer(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return VideoListTile(
                      video: video,
                      query: query,
                      hideChannel: hideChannel, 
                      playlistId: playlistId, 
                      playlistType: playlistType,
                      onLongPress:() {
                        select.toggle(video.youtubeId);
                        //showVideoListBottomSheet(
                        //  context: context,
                        //  video: video, 
                        //  hideChannel: hideChannel,
                        //  onWatched: (value) => provider.setWatched(value, video.youtubeId),
                        //  onDelete: () => provider.deleteVideo(video.youtubeId)
                        //);
                      },
                    );
                   }
                 ),
              if (provider.hasMore && videos.isNotEmpty && !horizontalScroll)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextButton(
                      onPressed: provider.fetchNext,
                      child: Text(localizations.listShowMore),
                    ),
                  ),
                )
            ]
          )
        );
      }
    );
  }
}
