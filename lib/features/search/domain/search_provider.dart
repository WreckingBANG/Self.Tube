import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:Self.Tube/features/search/data/api/search_api.dart';
import 'package:Self.Tube/features/search/data/models/searchwrapper_model.dart';
import 'package:Self.Tube/features/search/domain/search_query_provider.dart';
import 'package:Self.Tube/features/videos/data/api/video_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends AsyncNotifier<SearchWrapperModel?> {

  @override
  Future<SearchWrapperModel?> build() async {
    final query = ref.watch(searchQueryProvider);
    print("query: $query");
    if (query.isEmpty) return null;

    return await SearchApi().fetchSearch(query);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> deleteVideo(String id) async {
    final current = state.value!;
    await VideoApi.deleteVideo(id);

    final modified = current.videos.where((v) => v.youtubeId != id).toList();

    state = AsyncData(
      SearchWrapperModel(
        videos: modified,
        channels: current.channels,
        playlists: current.playlists
      )
    );
  }
  
  Future<void> deleteChannel(String id) async {
    final current = state.value!;
    await ChannelApi().deleteChannel(id);

    final modified = current.channels.where((c) => c.channelId != id).toList();

    state = AsyncData(
      SearchWrapperModel(
        videos: current.videos,
        channels: modified,
        playlists: current.playlists
      )
    );
  }

  Future<void> deletePlaylist(String id) async {
    final current = state.value!;
    await PlaylistApi.deletePlaylist(id, false);

    final modified = current.playlists.where((p) => p.playlistId != id).toList();

    state = AsyncData(
      SearchWrapperModel(
        videos: current.videos,
        channels: current.channels,
        playlists: modified
      )
    );
  }

  Future<void> setVideoWatched(bool value, String id) async {
    final current = state.value!;
    await VideoApi.setVideoWatched(id, value);

    final modified = current.videos.map((v) {
      if (v.youtubeId == id) {
        return v.copyWith(watched: value);
      }
      return v;
    }).toList(); 

    state = AsyncData(
      SearchWrapperModel(
        videos: modified,
        channels: current.channels,
        playlists: current.playlists
      )
    );
  }
}

final searchProvider = AsyncNotifierProvider (
  SearchNotifier.new,
);
