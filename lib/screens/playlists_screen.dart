import 'package:Self.Tube/widgets/tiles/playlist_list_tile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/widgets/containers/refresh_container.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: RefreshContainer(
        child: ListView(
          children: [
            FutureBuilder<List?>(
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
                  return ListSectionContainer(
                    children: [
                      ...List.generate(playlist.length, (index) {
                        return PlaylistListTile(playlist: playlist[index]);
                      }),
                    ],
                  );
                }
              },
            )
          ]
        )
      )
    );
  }
}
