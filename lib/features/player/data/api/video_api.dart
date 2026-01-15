import 'dart:convert';
import 'package:Self.Tube/common/data/models/videolist_wrapper_model.dart';
import 'package:Self.Tube/common/data/services/api/api_service.dart';
import 'package:Self.Tube/features/player/data/models/videolist_similar_model.dart';
import 'package:Self.Tube/features/player/data/models/videoplayer_model.dart';

class VideoApi {
  Future<VideoListWrapperModel?> fetchVideoList(String options) {
    return ApiService.request(
      url: '/api/video$options',
      method: 'GET',
      parser: (json) => VideoListWrapperModel.fromJson(json),
    );
  }

  Future<List<VideoListSimilarItemModel>?> fetchSimilarVideoList(String id) {
    return ApiService.request(
      url: '/api/video/$id/similar',
      method: 'GET',
      parser: (json) => VideoListSimilarItemModel.fromJsonList(json),
    );
  }

  static Future<VideoPlayerModel?> fetchVideoPlayer(String id) {
    return ApiService.request(
      url: '/api/video/$id',
      method: 'GET',
      parser: (json) => VideoPlayerModel.fromJson(json),
    );
  }

  static Future<bool?> setVideoProgress(String id, int position){
    return ApiService.request(
      url: '/api/video/$id/progress/', 
      method: 'POST', 
      body: json.encode({'position': position}),
      parser: (_) => true,
    );
  }

  static Future<bool?> setVideoWatched(String id, bool watched){
    return ApiService.request(
      url: '/api/watched/', 
      method: 'POST', 
      body: json.encode({
        'id': id,
        'is_watched': watched
      }),
      parser: (_) => true,
    );
  }
}