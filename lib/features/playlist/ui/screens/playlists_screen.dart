import 'package:Self.Tube/common/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/features/playlist/ui/dialogs/add_playlist_dialog.dart';
import 'package:Self.Tube/features/playlist/ui/sections/playlist_list_section.dart';
import 'package:flutter/material.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      floatingActionButton: UserSession.isPrivileged 
        ?  FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddPlaylistDialog()
              );
            },
              tooltip: localizations.playlistAdd,
              child: Icon(Icons.add),
          )
        : null,
      body: RefreshContainer(
        child: ListView(
          children: [
            PlaylistListSection()
          ],
        )
      ),
    );
  }
}
