import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/features/player/ui/tiles/mini_player_tile.dart';
import 'package:Self.Tube/features/playlist/domain/playlistpage_provider.dart';
import 'package:Self.Tube/features/videos/domain/videolist_provider.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistpageScreen extends ConsumerWidget{
  final String playlistId;

  const PlaylistpageScreen({
    super.key,
    required this.playlistId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final provider = ref.read(playlistPageProvider(playlistId).notifier);
    final playlist = ref.watch(playlistPageProvider(playlistId));
    final query = "?playlist=$playlistId";

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.playlistTitle),
      ),
      body: MiniPlayerTile(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(playlistPageProvider);
            ref.read(videoListProvider(query).notifier).refresh();
          },
          child: playlist.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
            data: (playlist) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(playlist!.playlistName),
                    leading: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomNetwokImage(imageLink: playlist.playlistPic)
                      ),
                    ),
                    trailing: playlist.playlistType == "regular"
                      ? playlist.playlistSubscribed
                          ? FilledButton(
                              onPressed: () {
                                ConfirmationDialog(
                                  context: context, 
                                  onSure: () {
                                    provider.subscribe(false);
                                  }
                                ); 
                              },
                              child: Text(localizations.playerUnsubscribe),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                provider.subscribe(true);
                              },
                              child: Text(localizations.playerSubscribe),
                            )
                      : null
                  ),
                  SizedBox(height: 20),
                  VideoListSection(
                    title: localizations.playlistVideos, 
                    query: query, 
                    showSorting: false,
                    hideChannel: false, 
                    playlistId: playlistId,
                    playlistType: playlist.playlistType,
                  ),
                ] 
              );
            }
          )
        )
      )
    );
  }
}

