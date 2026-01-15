import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/tiles/video_list_tile.dart';
import 'package:Self.Tube/features/channel/ui/tiles/channel_list_tile.dart';
import 'package:Self.Tube/features/playlist/ui/tiles/playlist_list_tile.dart';
import 'package:Self.Tube/features/search/data/api/search_api.dart';
import 'package:Self.Tube/features/search/data/models/searchwrapper_model.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({super.key});

  @override
  State<SearchScreenWidget> createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> {
  final SearchController _searchController = SearchController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) {
        return IconButton(
          icon: Icon(Icons.search),
          onPressed: () => controller.openView(),
        );
      },
      suggestionsBuilder: (context, controller) {
        if (_query.isEmpty) {
          return [
            ListTile(title: Text(localizations.searchTooltip))
          ];
        }
        return [
          SizedBox(
            child: FutureBuilder<SearchWrapperModel?>(
              future: SearchApi().fetchSearch(_query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text(localizations.errorFailedToLoadData),
                  );
                } else if (!snapshot.hasData) {
                  return ListTile(
                    title: Text(localizations.errorNoDataFound),
                  );
                }
                final result = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListSectionContainer(
                      title: localizations.searchChannels,
                      children: [
                        ...result.channels.map(
                          (c) => ChannelListTile(channel: c),
                        )
                      ],
                    ),
                    ListSectionContainer(
                      title: localizations.searchVideos,
                      children: [
                        ...result.videos.map(
                          (v) => VideoListTile(video: v, hideChannel: false),
                        )
                      ],
                    ),
                    ListSectionContainer(
                      title: localizations.searchPlaylists,
                      children: [
                        ...result.playlists.map(
                          (p) => PlaylistListTile(playlist: p),
                        )
                      ],
                    ),
                  ],
                );
              },
            )
          )
        ];
      }
    );
  }
}