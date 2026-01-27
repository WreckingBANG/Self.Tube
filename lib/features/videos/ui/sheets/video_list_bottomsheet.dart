import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/playlist/ui/dialogs/add_to_playlist_dialog.dart';
import 'package:Self.Tube/features/videos/data/api/video_api.dart';
import 'package:flutter/material.dart';
import '../../../../common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
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
              Navigator.pop(context);
              VideoApi.setVideoWatched(video.youtubeId, true);
            },
          ),
          ListTile(
            leading: Icon(Icons.timer_off_outlined),
            title: Text(localizations.sheetMarkUnwatched),
            onTap: () {
              Navigator.pop(context);
              VideoApi.setVideoWatched(video.youtubeId, false);
            },
          ),
          if (!hideChannel)
            ListTile(
              leading: Icon(Icons.person_2_rounded),
              title: Text(localizations.sheetOpenChannel),
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  AppRouter.channelpageScreen,
                  arguments: video.channelId
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
            leading: Icon(Icons.playlist_add_check_rounded),
            title: Text("Add to Playlist"),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AddToPlaylistDialog(videoId: video.youtubeId),
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
