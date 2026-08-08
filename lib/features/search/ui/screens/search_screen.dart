import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:Self.Tube/features/search/domain/search_provider.dart';
import 'package:Self.Tube/features/search/domain/search_query_provider.dart';
import 'package:Self.Tube/features/videos/ui/sheets/video_list_bottomsheet.dart';
import 'package:Self.Tube/features/videos/ui/tiles/video_list_tile.dart';
import 'package:Self.Tube/features/channel/ui/tiles/channel_list_tile.dart';
import 'package:Self.Tube/features/playlist/ui/tiles/playlist_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).set(_searchController.text);
    });
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final provider = ref.read(searchProvider.notifier);
    final search = ref.watch(searchProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(7.5),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: null,
                      controller: _searchController,
                    )
                  )
                ]
              )
            ),
            Divider(),
            Expanded(
              child: search.when(
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
                data: (search) {

                if (search == null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        M3EContainer.gem(
                          width: 100,
                          height: 100,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          child: Icon(
                            Symbols.database_search_rounded,
                            size: 50,
                          )
                        ),
                        SizedBox(height: 10),
                        Text(localizations.searchTooltip)
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListSectionContainer(
                          title: localizations.searchChannels,
                          itemCount: search.channels.length,
                          itemBuilder: (context, index) {
                            final channel = search.channels[index];
                            return ChannelListTile(
                              channel: channel, 
                              onDelete: () => provider.deleteChannel(channel.channelId)
                            );
                          },
                        ),
                        ListSectionContainer(
                          title: localizations.searchVideos,
                          itemCount: search.videos.length,
                          itemBuilder: (context, index) {
                            final video = search.videos[index];
                            return VideoListTile(
                              video: video,
                              query: "search",
                              hideChannel: false,
                              onPress: () => VideoPlayerService.loadVideo(video.youtubeId, true, context),
                              onLongPress: () {
                                showVideoListBottomSheet(
                                  context: context,
                                  video: video, 
                                  hideChannel: false,
                                  onWatched: (value) => provider.setVideoWatched(value, video.youtubeId),
                                  onDelete: () => provider.deleteVideo(video.youtubeId)
                                );
                              }
                            );
                          },
                        ),
                        ListSectionContainer(
                          title: localizations.searchPlaylists,
                          itemCount: search.playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = search.playlists[index];
                            return PlaylistListTile(
                              playlist: playlist, 
                              onDelete: () => provider.deletePlaylist(playlist.playlistId)
                            );
                          },
                        ),
                      ],
                    )
                  );
                }
              )
            )
          ],
        )
      )
    ); 
  }
}
