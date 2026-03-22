import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/search/domain/search_provider.dart';
import 'package:Self.Tube/features/search/domain/search_query_provider.dart';
import 'package:Self.Tube/features/videos/ui/tiles/video_list_tile.dart';
import 'package:Self.Tube/features/channel/ui/tiles/channel_list_tile.dart';
import 'package:Self.Tube/features/playlist/ui/tiles/playlist_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              child: SingleChildScrollView(
                child: search.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
                  data: (search) {
                    if (search == null) {
                      return ListTile(title: Text(localizations.searchTooltip));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListSectionContainer(
                          title: localizations.searchChannels,
                          children: [
                            ...search.channels.map(
                              (c) => ChannelListTile(
                                channel: c, 
                                onDelete: () => provider.deleteChannel(c.channelId)
                              ),
                            )
                          ],
                        ),
                        ListSectionContainer(
                          title: localizations.searchVideos,
                          children: [
                            ...search.videos.map(
                              (v) => VideoListTile(
                                video: v, 
                                hideChannel: false,
                                onWatched: (value) => provider.setVideoWatched(value, v.youtubeId),
                                onDelete: () => provider.deleteVideo(v.youtubeId),
                              ),
                            )
                          ],
                        ),
                        ListSectionContainer(
                          title: localizations.searchPlaylists,
                          children: [
                            ...search.playlists.map(
                              (p) => PlaylistListTile(
                                playlist: p, 
                                onDelete: () => provider.deletePlaylist(p.playlistId)
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                )
              )
            )
          ],
        )
      )
    ); 
  }
}
