import 'package:Self.Tube/services/api/search_api.dart';
import 'package:Self.Tube/widgets/tiles/channel_list_tile.dart';
import 'package:Self.Tube/widgets/tiles/video_list_tile.dart';
import 'package:flutter/material.dart';
import '../models/search/searchwrapper_model.dart';
import '../widgets/tiles/playlist_list_tile.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen>{

  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _searchQuery = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.searchTitle)),
      body:
      Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25) )
              ),
              labelText: localizations.searchLabel,
            ),
          ),
          _searchQuery != ""  
          ?  FutureBuilder<SearchWrapperModel?>(
              future: SearchApi().fetchSearch(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(localizations.errorFailedToLoadData));
                } else if (!snapshot.hasData) {
                  return Center(child: Text(localizations.errorNoDataFound));
                } else {
                  final result = snapshot.data!;
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListSectionContainer(
                            title: localizations.searchChannels,
                            children: [
                              ...List.generate(result.channels.length, (index) {
                                  return ChannelListTile(channel: result.channels[index]);
                                }
                              )
                            ]
                          ),

                          ListSectionContainer(
                            title: localizations.searchVideos,
                            children: [
                              ...List.generate(result.videos.length, (index) {
                                  return VideoListTile(
                                    video: result.videos[index],
                                    hideChannel: false,
                                  );
                                }
                              )
                            ]
                          ),

                          ListSectionContainer(
                            title: localizations.searchPlaylists,
                            children: [
                              ...List.generate(result.playlists.length, (index) {
                                  return PlaylistListTile(playlist: result.playlists[index]);
                                }
                              )
                            ]
                          )
                        ],
                      ),
                    )
                  );
                }
              },
            )
          : Text("Type to Search")
        ],
      )
    );
  }
}