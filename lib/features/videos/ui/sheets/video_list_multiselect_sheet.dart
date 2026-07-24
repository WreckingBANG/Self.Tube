import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/videos/domain/selection_provider.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class VideoListMultiselectSheet extends ConsumerWidget {
  final String query;
  final bool hideChannel;  

  const VideoListMultiselectSheet({
    super.key,
    required this.query,
    this.hideChannel = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
  
    final select = ref.read(selectionProvider(query).notifier);
    final selection = ref.watch(selectionProvider(query));

    return DraggableScrollableSheet(
      snap: true,
      maxChildSize: 0.6,
      initialChildSize: 0.2,
      minChildSize: 0.2,
      builder: (context, scrollController) {
        return Material(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => select.clear(), 
                    icon: Icon(Icons.close)
                  ),
                ),
                SizedBox(height: 15),
                ListSectionContainer(
                  title: localizations.sheetLocalActions,
                  children: [
                    ListTile(
                      leading: Icon(Icons.timer_outlined),
                      title: Text(localizations.sheetMarkWatched),
                      onTap: () {
                        select.setWatched(true);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.timer_off_outlined),
                      title: Text(localizations.sheetMarkUnwatched),
                      onTap: () {
                        select.setWatched(false);
                      },
                    ),
                    if (!hideChannel && selection.length == 1)
                      ListTile(
                        leading: Icon(Icons.person_2_rounded),
                        title: Text(localizations.sheetOpenChannel),
                        onTap: () {
                        },
                      ),
                    if (selection.length == 1)
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text(localizations.sheetShare),
                        onTap: () {
                          SharePlus.instance.share(
                            ShareParams(uri: Uri.parse("https://www.youtube.com/watch?v=${selection[0]}"))
                          );
                        },
                      ),
                    if (UserSession.isPrivileged)
                      ListTile(
                        leading: Icon(Icons.playlist_add_check_rounded),
                        title: Text("Add to Playlist"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ListTile(
                      leading: Icon(Icons.file_download_outlined),
                      title: Text(localizations.sheetDownloadLocal),
                      subtitle: Text(localizations.sheetComingSoon),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]
                ),
                if (UserSession.isPrivileged)
                  ListSectionContainer(
                    title: localizations.sheetServerActions,
                    children: [
                      ListTile(
                        leading: Icon(Icons.cloud_download),
                        title: Text(localizations.sheetRedownloadServer),
                        onTap: () {
                          ConfirmationDialog(
                            context: context, 
                            onSure: select.redownloadVideos 
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.cloud_off_rounded),
                        title: Text(localizations.sheetDeleteVideoServer),
                        onTap: () {
                          ConfirmationDialog(
                            context: context,
                            onSure: select.deleteVideos
                          ); 
                        },
                      ),
                    ]
                  ),
              ],
            )
          )
        );
      },
    );

  }

}
