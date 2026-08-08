import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/playlist/ui/dialogs/add_to_playlist_dialog.dart';
import 'package:Self.Tube/features/videos/domain/selection_provider.dart';
import 'package:Self.Tube/features/videos/ui/dialogs/multiselect_progress_dialog.dart';
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
          ),
          elevation: 10,
          //color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: EdgeInsets.only(
              top: 15,
              left: 5,
              right: 5
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10
                        ),
                        child: selection.length > 1 
                          ? Text(localizations.sheetMultiItems(selection.length.toString()))                  
                          : Text(localizations.sheetSingleItem(selection.length.toString()))
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10
                        ),
                        child: IconButton(
                          onPressed: () => select.clear(), 
                          icon: Icon(Icons.close)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ListSectionContainer(
                    title: localizations.sheetLocalActions,
                    children: [
                      ListTile(
                        leading: Icon(Icons.timer_outlined),
                        title: Text(localizations.sheetMarkWatched),
                        onTap: () {
                          ProgressDialog(
                            context: context, 
                            query: query, 
                            action: () => select.setWatched(true),
                            ref: ref
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.timer_off_outlined),
                        title: Text(localizations.sheetMarkUnwatched),
                        onTap: () {
                          ProgressDialog(
                            context: context, 
                            query: query, 
                            action: () => select.setWatched(false), 
                            ref: ref
                          );
                        },
                      ),
                      if (!hideChannel && selection.length == 1)
                        ListTile(
                          leading: Icon(Icons.person_2_rounded),
                          title: Text(localizations.sheetOpenChannel),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRouter.channelpageScreen,
                              arguments: select.getChannelId(selection[0])  
                            ); 
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
                          onTap: () async {
                            final playlistId = await showDialog(
                              context: context,
                              builder: (context) => AddToPlaylistDialog(returnOnly: true)
                            );
                            ProgressDialog(
                              context: context, 
                              query: query, 
                              action: () => select.addToPlaylist(playlistId), 
                              ref: ref
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
                              onSure: () => ProgressDialog(
                                context: context,
                                query: query,
                                action: () => select.redownloadVideos(),
                                ref: ref
                              ) 
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.cloud_off_rounded),
                          title: Text(localizations.sheetDeleteVideoServer),
                          onTap: () {
                            ConfirmationDialog(
                              context: context, 
                              onSure: () => ProgressDialog(
                                context: context,
                                query: query,
                                action: () => select.deleteVideos(),
                                ref: ref
                              ) 
                            );
                          },
                        ),
                      ]
                    ),
                ],
              )
            )
          )
        );
      },
    );
  }
}
