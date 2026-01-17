import 'package:Self.Tube/common/data/services/api/api_service.dart';
import 'package:Self.Tube/features/playlist/data/models/playlistlist_wrapper_model.dart';

class PlaylistApi {
  Future<PlaylistListWrapperModel?> fetchPlaylistList() {
    return ApiService.request(
      url: '/api/playlist',
      method: 'GET',
      parser: (json) => PlaylistListWrapperModel.fromJson(json),
    );
  } 
}