import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/playlist/domain/playlistlist_provider.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/features/playlist/ui/dialogs/add_playlist_dialog.dart';
import 'package:Self.Tube/features/playlist/ui/sections/playlist_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistsScreen extends ConsumerWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final query = "";
    final provider = ref.read(playlistListProvider(query).notifier);

    return Scaffold(
      floatingActionButton: UserSession.isPrivileged 
        ?  FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddPlaylistDialog(query: query)
              );
            },
              tooltip: localizations.playlistAdd,
              child: Icon(Icons.add),
          )
        : null,
      body: RefreshIndicator(
        onRefresh: () async {
          provider.refresh();
        },
        child: ListView(
          children: [
            PlaylistListSection(query: query)
          ],
        )
      ),
    );
  }
}
