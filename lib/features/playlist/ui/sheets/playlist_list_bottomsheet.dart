import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/playlist/domain/playlistlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showPlaylistListBottomSheet({
  required BuildContext context,
  required dynamic playlist,
  required WidgetRef ref,
  required String query,
  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;

  final provider = ref.read(playlistListProvider(query).notifier);

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
          if (UserSession.isPrivileged)
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text(localizations.playlistDelete),
              onTap: () {
                ConfirmationDialog(
                  context: context, 
                  onSure: () {
                    provider.deletePlaylist(playlist.playlistId);
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
