import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showPlaylistListBottomSheet({
  required BuildContext context,
  required dynamic playlist,
  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  return showBottomSheetTemplate(
    context: context, 
    title: playlist.playlistName,
    children: [
      ListSectionContainer(
        children: [
          if (playlist.playlistType == "regular")
            ListTile(
              leading: Icon(Icons.share),
              title: Text(localizations.sheetShare),
              onTap: () {
                SharePlus.instance.share(
                  ShareParams(uri: Uri.parse("https://www.youtube.com/playlist?list=${playlist.playlistId}"))
                );
              },
            ),
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text("Delete Playlist"),
            onTap: () {
              ConfirmationDialog(
                context: context, 
                onSure: () {
                  PlaylistApi.deletePlaylist(playlist.playlistId, false);
                  Navigator.pop(context);
                }
              );
            },
          ),
        ]
      ),
    ]
  );
}
