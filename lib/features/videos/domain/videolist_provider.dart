import 'package:Self.Tube/features/videos/data/api/video_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListNotifier extends AsyncNotifier<List?> {
  VideoListNotifier(this.query);
  late final query;
  int currentPage = 1;
  bool hasMore = true;
  String sortOptions = "";

  @override
  Future<List?> build() async {
    final videos = await VideoApi().fetchVideoList("$query$sortOptions&page=$currentPage");

    if (videos != null) {
      if (currentPage >= videos.lastPage) {
        hasMore = false;
      }

      return videos.data;
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

    final newPage = await VideoApi().fetchVideoList("$query&page=$currentPage");
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

  Future<void> setSorting(String value) async {
    sortOptions = value;
    ref.invalidateSelf();
  }

  Future<void> deleteVideo(String id) async {
    final current = state.value!;
    await VideoApi.deleteVideo(id);

    final modified = current.where((v) => v.videoId != id).toList();

    state = AsyncData(modified);
  }
}

final videoListProvider = AsyncNotifierProvider.family<VideoListNotifier, List?, String> (
  VideoListNotifier.new,
);
