import 'package:Self.Tube/features/playlist/data/models/playlistlist_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';

class PlaylistPageNotifier extends AsyncNotifier<PlaylistListItemModel?> {
  PlaylistPageNotifier(this.id);
  late final String id;

  @override
  Future<PlaylistListItemModel?> build() async {
    return PlaylistApi().fetchPlaylist(id);
  }

  Future<void> subscribe(bool val) async {
    await AsyncValue.guard(() => PlaylistApi.modifyRegularPlaylistState(id, val));
    state = await AsyncValue.guard(() => PlaylistApi().fetchPlaylist(id));
  }

}

final playlistPageProvider = AsyncNotifierProvider.family<PlaylistPageNotifier, PlaylistListItemModel?, String>(
  PlaylistPageNotifier.new,
);
