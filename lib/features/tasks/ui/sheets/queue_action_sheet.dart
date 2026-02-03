import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

Future<void> showQueueActionBottomSheet({
  required BuildContext context,
  required dynamic video,

  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  return showBottomSheetTemplate(
    context: context, 
    title: video.title,
    children: [
      ListSectionContainer(
        children: [
          ListTile(
            leading: Icon(Icons.timer_outlined),
            title: Text("Download Now"),
            onTap: () {
              TaskApi().changeVideoQueueStatus(video.youtubeId, "priority");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.timer_off_outlined),
            title: Text("Ignore"),
            onTap: () {
              TaskApi().changeVideoQueueStatus(video.youtubeId, "ignore");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.timer_off_outlined),
            title: Text("Delete from Queue"),
            onTap: () {
              TaskApi().deleteSingleVideoQueue(video.youtubeId);
              Navigator.pop(context);
            },
          ),
        ]
      ),
    ]
  );
}
