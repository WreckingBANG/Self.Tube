import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showChannelListBottomSheet({
  required BuildContext context,
  required dynamic channel,
  required WidgetRef ref,
  required Function()? onDelete,
  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;

  return showBottomSheetTemplate(
    context: context, 
    title: channel.channelName,
    children: [
      ListSectionContainer(
        children: [
          ListTile(
            leading: Icon(Icons.share),
            title: Text(localizations.sheetShare),
            onTap: () {
              SharePlus.instance.share(
                ShareParams(uri: Uri.parse("https://www.youtube.com/channel/${channel.channelId}"))
              );
            },
          ),
          if (UserSession.isPrivileged)
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text(localizations.channelDelete),
              onTap: () {
                ConfirmationDialog(
                  context: context, 
                  onSure: () {
                    onDelete?.call();
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
