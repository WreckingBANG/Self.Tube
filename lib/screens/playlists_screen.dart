import 'package:Self.Tube/widgets/playlist_list_tile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self.Tube"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List?>(
          future: ApiService.fetchPlaylistList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No user found"));
            } else {
              final playlist = snapshot.data!;
              return Column(
                children: [
                  ...List.generate(playlist.length, (index) {
                    return PlaylistListTile(playlist: playlist[index]);
                  }),
                ],
              );
            }
          },
        ),
      )
    );
  }
}
