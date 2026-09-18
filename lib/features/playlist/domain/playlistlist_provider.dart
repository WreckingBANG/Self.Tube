import 'package:Self.Tube/common/domain/pagination_mixin.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session_provider.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistListNotifier extends AsyncNotifier<List?> with PaginationMixin {
  PlaylistListNotifier(this.query);
  late final String query;

  @override
  Future<List?> build() async {
    final isLoggedIn = ref.watch(userSessionProvider).value ?? false;

    if (!isLoggedIn) {
      pagination.currentPage = 1;
      pagination.hasMore = true;
      return [];
    }

    final result = await getData();

    if (result.hasError == false) {
      return result.data;
    }
    
    return [];
  }

  @override 
  Future<PageResult> apiLoader(String query) async {
     
    final result  = await PlaylistApi().fetchPlaylistList(query);
    
    if (result == null) {
      return PageResult(hasError: true);
    }

    return PageResult(
      data: result.data, 
      lastPage: result.lastPage
    ); 
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
