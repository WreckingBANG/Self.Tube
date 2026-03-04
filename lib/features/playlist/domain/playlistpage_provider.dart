import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';

final playlistPageProvider = FutureProvider.family((ref, String id) async {
  return PlaylistApi().fetchPlaylist(id);
});


final playlistActionProvider = Provider((ref) {
  return PlaylistActions(ref);
});

class PlaylistActions {
  final Ref ref;
  PlaylistActions(this.ref);

  Future<void> toggleSubscription(String id, bool subscribe) async {
    await PlaylistApi.modifyRegularPlaylistState(id, subscribe);
    ref.invalidate(playlistPageProvider(id));
  }
}
