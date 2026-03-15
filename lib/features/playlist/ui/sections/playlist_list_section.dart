import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/playlist/domain/playlistlist_provider.dart';
import 'package:Self.Tube/features/playlist/ui/tiles/playlist_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistListSection extends ConsumerWidget {
  final String title;
  final String query;
  final bool hideIfEmpty;

  const PlaylistListSection({
    super.key,
    required this.query,
    this.title = "",
    this.hideIfEmpty = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final provider = ref.read(playlistListProvider(query).notifier);
    final playlists = ref.watch(playlistListProvider(query));

    return playlists.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
      data: (playlists) {
        return Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (playlists!.isEmpty && !hideIfEmpty)
              Center(child: Text(localizations.errorNoDataFound))
            else 
              ListSectionContainer(
                title: title,
                children: [
                  ...List.generate(playlists.length, (index) {
                    final playlist = playlists[index];
                    return PlaylistListTile(
                      playlist: playlist, 
                      onDelete: () => provider.deletePlaylist(playlist.playlistId)
                    );
                  })
                ],
              ),

            if (provider.hasMore && playlists.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: TextButton(
                    onPressed: provider.fetchNext,
                    child: Text(localizations.listShowMore),
                  )
                ),
              )
          ],
        );
      }
    );
  }
}
