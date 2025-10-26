import 'searchchannel_model.dart';
import 'searchvideo_model.dart';
import 'searchplaylist_model.dart';

class SearchWrapperModel {
  final List<SearchVideoModel> videos;
  final List<SearchChannelModel> channels;
  final List<SearchPlaylistModel> playlists;

  SearchWrapperModel({
    required this.videos,
    required this.channels,
    required this.playlists,
  });

  factory SearchWrapperModel.fromJson(Map<String, dynamic> json) {
    return SearchWrapperModel(
      videos: SearchVideoModel.fromJsonList(json),
      channels: SearchChannelModel.fromJsonList(json),
      playlists: SearchPlaylistModel.fromJsonList(json),
    );
  }
}