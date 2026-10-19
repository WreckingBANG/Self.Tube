import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/sections/empty_error_section.dart';
import 'package:Self.Tube/common/ui/widgets/pagination/pagination_buttons.dart';
import 'package:Self.Tube/common/ui/widgets/sections/sort_chips_section.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:Self.Tube/features/videos/domain/selection_provider.dart';
import 'package:Self.Tube/features/videos/domain/videolist_provider.dart';
import 'package:Self.Tube/features/videos/ui/containers/continue_watching_list.dart';
import 'package:Self.Tube/features/videos/ui/sheets/video_list_multiselect_sheet.dart';
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
    final mediaQuery =  MediaQuery.of(context);
    final usableSpace = (mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom)-56;

    final provider = ref.read(videoListProvider(query).notifier);
    final videos = ref.watch(videoListProvider(query));

    final select = ref.read(selectionProvider(query).notifier);
    final selection = ref.watch(selectionProvider(query));

    if (!_portalController.isShowing) {
      _portalController.show();
    }

    return videos.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator()
        ),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(
          child: Text(localizations.errorFailedToLoadData)
        ),
      ),
      data: (videos) {
        
        return SliverMainAxisGroup(
          slivers: [
            
            SliverToBoxAdapter(
              child: OverlayPortal(
                controller: _portalController,
                overlayChildBuilder: (context) {
                  if (selection.isEmpty) {
                    return const SizedBox.shrink();
                  } 
                  
                  return VideoListMultiselectSheet(
                    query: query,
                    hideChannel: hideChannel,
                  );
                },
              )
            ),

            if (showSorting)
              SliverToBoxAdapter(
                child: SortChipsSection(
                  sortOptions: (value) {
                    provider.setSorting(value);
                  },
                )
              ),
            
            if (horizontalScroll)
              SliverToBoxAdapter(
                child: ContinueWatchingList(
                  title: title,
                  itemCount: videos!.length,
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
              ),
               

            if (!horizontalScroll)
              ListSectionContainer(
                returnSliver: true,
                itemCount: videos!.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return VideoListTile(
                    video: video,
                    query: query,
                    hideChannel: hideChannel, 
                    playlistId: playlistId, 
                    playlistType: playlistType,
                    onPress: () {
                      if (selection.isNotEmpty) {
                        select.toggle(video.youtubeId);
                      } else {
                        VideoPlayerService.loadVideo(video.youtubeId, true, context);
                      }
                    },
                    onLongPress:() {
                      select.toggle(video.youtubeId);
                    },
                  );
                }
              ),

            if (!horizontalScroll)
              SliverToBoxAdapter(
                child: PaginationButtons(
                  currentPage: provider.pagination.currentPage,
                  lastPage: provider.pagination.lastPage,
                  hasMore: provider.pagination.hasMore,
                  goToPage: (page) => provider.goToPage(page),
                  fetchNext: () => provider.fetchNext()
                ),
              ),

            if (videos!.isEmpty && !hideIfEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: EmptyErrorSection()
                )
              ),

            if (selection.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(height: usableSpace*20/100)
              )

          ],
        );
      }
    );
  }
}
