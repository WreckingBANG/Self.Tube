import 'package:Self.Tube/models/playlist/playlistlist_wrapper_model.dart';
import 'api_service.dart';

class PlaylistApi {
  Future<PlaylistListWrapperModel?> fetchPlaylistList() {
    return ApiService.request(
      url: '/api/playlist',
      method: 'GET',
      parser: (json) => PlaylistListWrapperModel.fromJson(json),
    );
  } 
}