import 'package:Self.Tube/widgets/playlist_list_tile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/search_screen.dart';
import 'settings/overview_screen.dart';
import '../l10n/generated/app_localizations.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: localizations.searchTitle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: localizations.settingsTitle,
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
              return Center(child: Text(localizations.errorFailedToLoadData));
            } else if (!snapshot.hasData) {
              return Center(child: Text(localizations.errorNoDataFound));
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
