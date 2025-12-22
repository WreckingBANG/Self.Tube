import 'package:flutter/material.dart';
import './bottomsheet_template.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/services/api_service.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/screens/channelpage_screen.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showVideoListBottomSheet({
  required BuildContext context,
  required dynamic video,
  required bool hideChannel,

  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  return showBottomSheetTemplate(
    context: context, 
    title: video.title,
    children: [
      ListSectionContainer(
        title: localizations.sheetLocalActions,
        children: [
          ListTile(
            leading: Icon(Icons.timer_outlined),
            title: Text(localizations.sheetMarkWatched),
            onTap: () {
              ApiService.setVideoWatched(video.youtubeId, true);
            },
          ),
          ListTile(
            leading: Icon(Icons.timer_off_outlined),
            title: Text(localizations.sheetMarkUnwatched),
            onTap: () {
              ApiService.setVideoWatched(video.youtubeId, false);
            },
          ),
          if (!hideChannel)
            ListTile(
              leading: Icon(Icons.person_2_rounded),
              title: Text(localizations.sheetOpenChannel),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: video.channelId)),
                );
              },
            ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(localizations.sheetShare),
            onTap: () {
              SharePlus.instance.share(
                ShareParams(uri: Uri.parse("https://www.youtube.com/watch?v=${video.youtubeId}"))
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download_outlined),
            title: Text(localizations.sheetDownloadLocal),
            subtitle: Text(localizations.sheetComingSoon),
            onTap: () {},
          ),
        ]
      ),
      ListSectionContainer(
        title: localizations.sheetServerActions,
        children: [
          ListTile(
            leading: Icon(Icons.cloud_download),
            title: Text(localizations.sheetRedownloadServer),
            subtitle: Text(localizations.sheetComingSoon),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.cloud_off_rounded),
            title: Text(localizations.sheetDeleteVideoServer),
            subtitle: Text(localizations.sheetComingSoon),
            onTap: () {},
          ),
        ]
      ),
    ]
  );
}
