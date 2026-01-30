import 'dart:convert';
import 'package:Self.Tube/features/videos/data/models/videolist_wrapper_model.dart';
import 'package:Self.Tube/common/data/services/api/api_service.dart';

class VideoApi {
  Future<VideoListWrapperModel?> fetchVideoList(String options) {
    return ApiService.request(
      url: '/api/video$options',
      method: 'GET',
      parser: (json) => VideoListWrapperModel.fromJson(json),
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

  static Future<bool?> deleteVideo(String id){
    return ApiService.request(
      url: '/api/video/$id/',
      method: 'DELETE', 
      parser: (_) => true
    );
  }
}
