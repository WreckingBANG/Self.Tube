import 'package:Self.Tube/common/domain/pagination_mixin.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session_provider.dart';
import 'package:Self.Tube/features/videos/data/api/video_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListNotifier extends AsyncNotifier<List?> with PaginationMixin {
  VideoListNotifier(this.query);
  late final String query;

  @override
  Future<List?> build() async {
    pagination.query = query;
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
     
    final result  = await VideoApi().fetchVideoList(query);
    
    if (result == null) {
      return PageResult(hasError: true);
    }

    return PageResult(
      data: result.data, 
      lastPage: result.lastPage
    ); 
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

final videoListProvider = AsyncNotifierProvider.family<VideoListNotifier, List?, String> (
  VideoListNotifier.new,
);

