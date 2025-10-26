import 'package:Self.Tube/widgets/channel_list_tile.dart';
import 'package:Self.Tube/widgets/video_list_tile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/search/searchwrapper_model.dart';
import '../widgets/playlist_list_tile.dart';


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
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body:
      Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25) )
              ),
              labelText: 'Search...',
            ),
          ),
          _searchQuery != ""  
          ?  FutureBuilder<SearchWrapperModel?>(
              future: ApiService.fetchSearch(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("Nothing found..."));
                } else {
                  final result = snapshot.data!;
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: result.channels.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                child: ChannelListTile(channel: result.channels[index])
                              );
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: result.videos.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                child: VideoListTile(video: result.videos[index])
                              );
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: result.playlists.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                child: PlaylistListTile(playlist: result.playlists[index])
                              );
                            },
                          ),
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