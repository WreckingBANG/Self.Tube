import 'package:flutter/material.dart';
import './bottomsheet_template.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

Future<void> showVideoPlayerBottomSheet({
  required BuildContext context,

  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  return showBottomSheetTemplate(
    context: context, 
    children: [
      ListSectionContainer(
        children: [
          ListTile(
            leading: Icon(Icons.repeat_rounded),
            title: Text("Repeat mode"),
            subtitle: Text("None"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.fit_screen_rounded),
            title: Text("Border Mode"),
            subtitle: Text("Fit-Screen"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.speed),
            title: Text("Playback Speed"),
            subtitle: Text("1.0x"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.high_quality_outlined),
            title: Text("Quality"),
            subtitle: Text("Default - TubeArchivist"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.subtitles_rounded),
            title: Text("Subtitles"),
            subtitle: Text("Coming Soon"),
            onTap: () {},
          ),
        ],
      )
    ]
  );
}
