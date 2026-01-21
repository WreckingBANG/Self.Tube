import 'dart:convert';

import 'package:Self.Tube/common/data/services/api/api_service.dart';
import 'package:Self.Tube/features/playlist/data/models/playlistlist_model.dart';
import 'package:Self.Tube/features/playlist/data/models/playlistlist_wrapper_model.dart';

class PlaylistApi {

  Future<PlaylistListItemModel?> fetchPlaylist(String id) {
    return ApiService.request(
      url: '/api/playlist/$id',
      method: 'GET',
      parser: (json) => PlaylistListItemModel.fromJson(json),
    );
  }

  Future<PlaylistListWrapperModel?> fetchPlaylistList(String options) {
    return ApiService.request(
      url: '/api/playlist/$options',
      method: 'GET',
      parser: (json) => PlaylistListWrapperModel.fromJson(json),
    );
  }

  static Future<bool?> modifyCustomPlaylistItems(String playlistId, String videoId, String action){
    return ApiService.request(
      url: '/api/playlist/custom/$playlistId/', 
      method: 'POST', 
      body: json.encode({
        "action": action,
        "video_id": videoId
      }),
      parser: (_) => true,
    );
  }

  static Future<bool?> modifyRegularPlaylistState(String id, bool subscribed){
    return ApiService.request(
      url: '/api/playlist/$id/', 
      method: 'POST', 
      body: json.encode({
        "playlist_subscribed": subscribed,
        "playlist_sort_order": "top"
      }),
      parser: (_) => true,
    );
  }

  static Future<bool?> createCustomPlaylist(String name) {
    return ApiService.request(
      url: '/api/playlist/custom/',
      method: 'POST',
      body: json.encode({
        "playlist_name": name
      }),
      parser: (_) => true,
    );
  }

  static Future<bool?> addRegularPlaylist(String id) {
    return ApiService.request(
      url: '/api/playlist/',
      method: 'POST',
      body: json.encode({
        "data": [
          {
            "playlist_id": id,
            "playlist_subscribed": "true"
          }
        ]
      }),
      parser: (_) => true,
    );
  }

  static Future<bool?> deletePlaylist(String playlistId, bool deleteVideos){
    return ApiService.request(
      url: '/api/playlist/$playlistId/?delete_videos=$deleteVideos', 
      method: 'DELETE', 
      parser: (_) => true,
    );
  }

}