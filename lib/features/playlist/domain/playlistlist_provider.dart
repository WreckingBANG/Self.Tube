import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistListNotifier extends AsyncNotifier<List?> {
  PlaylistListNotifier(this.query);
  late final query;
  int currentPage = 1;
  bool hasMore = true;

  @override
  Future<List?> build() async {
    final playlists = await PlaylistApi().fetchPlaylistList("?page=$currentPage");

    if (playlists != null) {
      if (currentPage >= playlists.lastPage) {
        hasMore = false;
      }

      return playlists.data;
    }
    
    return [];
  }

  Future<void> refresh() async {
    hasMore = true;
    currentPage = 1;
    ref.invalidateSelf();
  }

  Future<void> fetchNext() async {
    final current = state.value!;

    currentPage++;

    final newPage = await PlaylistApi().fetchPlaylistList("$query&page=$currentPage");
    if (newPage != null) {
      if (currentPage >= newPage.lastPage) {
        hasMore = false;
      }

      final merged = [
        ...current,
        ...newPage.data,
      ];

      state = AsyncData(merged);
    }
  }

  Future<void> addPlaylist(String value, bool regular) async {
    if (regular) {
      await PlaylistApi.addRegularPlaylist(value);
      //TO-DO: Send user to Actions-Screen
    } else {
      await PlaylistApi.createCustomPlaylist(value);
      ref.invalidateSelf();
    }
  }

  Future<void> deletePlaylist(String id) async {
    final current = state.value!;
    await PlaylistApi.deletePlaylist(id, false);

    final modified = current.where((p) => p.playlistId != id).toList();

    state = AsyncData(modified);
  }
}

final playlistListProvider = AsyncNotifierProvider.family<PlaylistListNotifier, List?, String> (
  PlaylistListNotifier.new,
);
