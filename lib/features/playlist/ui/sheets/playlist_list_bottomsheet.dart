import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
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
          ListTile(
            leading: Icon(Icons.share),
            title: Text(localizations.sheetShare),
            onTap: () {
              SharePlus.instance.share(
                ShareParams(uri: Uri.parse("https://www.youtube.com/playlist?list=${playlist.playlistId}"))
              );
            },
          ),
        ]
      ),
    ]
  );
}
