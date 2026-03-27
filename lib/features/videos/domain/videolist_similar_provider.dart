import 'package:Self.Tube/features/videos/data/api/video_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListSimilarNotifier extends AsyncNotifier<List?> {
  VideoListSimilarNotifier(this.id);
  late final id;

  @override
  Future<List?> build() async {
    return await VideoApi().fetchSimilarVideoList(id);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> deleteVideo(String id) async {
    final current = state.value!;
    await VideoApi.deleteVideo(id);

    final modified = current.where((v) => v.youtubeId != id).toList();

    state = AsyncData(modified);
  }

  Future<void> setWatched(bool value, String id) async {
    final current = state.value!;
    await VideoApi.setVideoWatched(id, value);

    final modified = current.map((v) {
      if (v.youtubeId == id) {
        return v.copyWith(watched: value);
      }
      return v;
    }).toList(); 

    state = AsyncData(modified);
  }
}

final videoListSimilarProvider = AsyncNotifierProvider.autoDispose.family<VideoListSimilarNotifier, List?, String> (
  VideoListSimilarNotifier.new,
);
