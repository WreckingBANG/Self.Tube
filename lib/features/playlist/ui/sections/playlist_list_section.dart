import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/pagination/pagination_buttons.dart';
import 'package:Self.Tube/common/ui/widgets/sections/empty_error_section.dart';
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
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator()
        ),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(
          child: Text(localizations.errorFailedToLoadData)
        ),
      ),
      data: (playlists) {
        
        return SliverMainAxisGroup (
          slivers: [
            
            if (playlists!.isEmpty && !hideIfEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: EmptyErrorSection()
                )
              )
            else 
              ListSectionContainer(
                returnSliver: true,
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return PlaylistListTile(
                    playlist: playlist, 
                    onDelete: () => provider.deletePlaylist(playlist.playlistId)
                  );
                },  
              ),
            SliverToBoxAdapter(
              child: PaginationButtons(
                currentPage: provider.pagination.currentPage,
                lastPage: provider.pagination.lastPage, 
                hasMore: provider.pagination.hasMore,
                goToPage: (page) => provider.goToPage(page),
                fetchNext: () => provider.fetchNext()
              ),
            )
          ],
        );
      }
    );
  }
}
