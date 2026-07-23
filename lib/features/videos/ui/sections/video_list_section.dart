import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/sections/empty_error_section.dart';
import 'package:Self.Tube/common/ui/widgets/sections/sort_chips_section.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
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
            
            return DraggableScrollableSheet(
                snap: true,
                maxChildSize: 0.6,
                initialChildSize: 0.2,
                minChildSize: 0.2,
                builder: (context, scrollController) {
                  return Material(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => select.clear(), 
                              icon: Icon(Icons.close)
                            ),
                          ),
                          SizedBox(height: 15),
                          ListSectionContainer(
                            title: localizations.sheetLocalActions,
                            children: [
                              ListTile(
                                leading: Icon(Icons.timer_outlined),
                                title: Text(localizations.sheetMarkWatched),
                                onTap: () {
                                  select.setWatched(true);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.timer_off_outlined),
                                title: Text(localizations.sheetMarkUnwatched),
                                onTap: () {
                                  select.setWatched(false);
                                },
                              ),
                              if (!hideChannel && selection.length == 1)
                                ListTile(
                                  leading: Icon(Icons.person_2_rounded),
                                  title: Text(localizations.sheetOpenChannel),
                                  onTap: () {
                                  },
                                ),
                              if (selection.length == 1)
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text(localizations.sheetShare),
                                  onTap: () {
                                  },
                                ),
                              if (UserSession.isPrivileged)
                                ListTile(
                                  leading: Icon(Icons.playlist_add_check_rounded),
                                  title: Text("Add to Playlist"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ListTile(
                                leading: Icon(Icons.file_download_outlined),
                                title: Text(localizations.sheetDownloadLocal),
                                subtitle: Text(localizations.sheetComingSoon),
                                onTap: () {},
                              ),
                            ]
                          ),
                          if (UserSession.isPrivileged)
                            ListSectionContainer(
                              title: localizations.sheetServerActions,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.cloud_download),
                                  title: Text(localizations.sheetRedownloadServer),
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.cloud_off_rounded),
                                  title: Text(localizations.sheetDeleteVideoServer),
                                  onTap: () {
                                    ConfirmationDialog(
                                      context: context,
                                      onSure: select.deleteVideos
                                    ); 
                                  },
                                ),
                              ]
                            ),
                        ],
                      )
                    )
                  );
                },
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
