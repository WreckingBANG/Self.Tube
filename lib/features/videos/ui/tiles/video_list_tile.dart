import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:Self.Tube/common/utils/duration_formatter.dart';
import 'package:Self.Tube/common/utils/number_formatter.dart';
import 'package:Self.Tube/common/utils/timeago_formatter.dart';
import 'package:Self.Tube/features/videos/domain/selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListTile extends ConsumerWidget {
  final dynamic video;
  final String query;
  final bool hideChannel;
  final String playlistId;
  final String playlistType;
  final void Function()? onPress;
  final void Function()? onLongPress;

  const VideoListTile({
    super.key, 
    required this.video,
    required this.query,
    required this.hideChannel,
    required this.onPress,
    required this.onLongPress,
    this.playlistId = "",
    this.playlistType = "",
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final selection = ref.watch(selectionProvider(query));

    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),  
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 170,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (selection.contains(video.youtubeId))
                        Container(
                          width: 170, 
                          color: Theme.of(context).colorScheme.primary 
                        ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,                         
                        width: selection.contains(video.youtubeId) ? 150.0 : 170.0,
                        clipBehavior: Clip.antiAlias,                         
                        decoration: BoxDecoration(
                          borderRadius: selection.contains(video.youtubeId)
                              ? BorderRadius.circular(15)
                              : BorderRadius.zero,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                selection.contains(video.youtubeId)
                                  ? Colors.black.withOpacity(0.25)
                                  : Colors.transparent,
                                BlendMode.srcATop,
                              ),
                              child: CustomNetworkImage(
                                imageLink: video.thumbnail,
                                logicalWidth: 170, 
                              ),
                            ),
                            if (selection.contains(video.youtubeId))
                              Positioned(
                                top: 2,
                                left: 2,
                                child: Icon(
                                  color: Theme.of(context).colorScheme.primary,
                                  Icons.check_circle)
                              ),
                            (video.progress != 0 || video.watched == true) && !selection.contains(video.youtubeId)
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: LinearProgressIndicator(
                                    value: video.progress != 0 ? video.progress / 100 : 1.0,
                                    minHeight: 4,
                                  )
                                )
                              : SizedBox.shrink(),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  formatDuration(video.duration),
                                  style: const TextStyle(fontSize: 10, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                )   
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${formatNumberCompact(video.views, context)} ${localizations.videoListViews} • ${formatTimeAgo(context, video.videoDate)}",
                      style: TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!hideChannel)
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context, 
                            AppRouter.channelpageScreen,
                            arguments: video.channelId
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      CustomNetworkImage(
                                        imageLink: video.channelThumb,
                                        logicalWidth: 22,
                                      )
                                    ],
                                  ),
                                )   
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              video.channelName,
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        )
                      )
                  ],
                ),
              )  
            ),
            playlistId != "" && playlistType == "custom" && UserSession.isPrivileged
              ? IconButton(
                  onPressed: () {
                    ConfirmationDialog(
                      context: context, 
                      onSure: () {
                        PlaylistApi.modifyCustomPlaylistItems(
                          playlistId, 
                          video.youtubeId, 
                          "remove"
                        );
                      }
                    );
                  },
                  icon: Icon(Icons.playlist_remove),
                )
              : SizedBox()
          ],
        ),
        onTap: () => onPress?.call(),
        onLongPress: () => onLongPress?.call()
      ),
    );
  }
}

