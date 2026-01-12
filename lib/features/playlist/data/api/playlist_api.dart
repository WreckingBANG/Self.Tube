import 'api_service.dart';
import 'package:Self.Tube/data/models/playlist/playlistlist_wrapper_model.dart';

class PlaylistApi {
  Future<PlaylistListWrapperModel?> fetchPlaylistList() {
    return ApiService.request(
      url: '/api/playlist',
      method: 'GET',
      parser: (json) => PlaylistListWrapperModel.fromJson(json),
    );
  } 
}