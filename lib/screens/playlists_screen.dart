import 'package:Self.Tube/widgets/playlist_list_tile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../l10n/generated/app_localizations.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
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
