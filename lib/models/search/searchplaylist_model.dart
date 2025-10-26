class SearchPlaylistModel {
  final String playlistId;
  final String playlistName;
  final String playlistChannelName;
  final String playlistChannelId;
  final String playlistPic;
  final bool playlistSubscribed;

  SearchPlaylistModel({
    required this.playlistId,
    required this.playlistName,
    required this.playlistChannelName,
    required this.playlistChannelId,
    required this.playlistPic,
    required this.playlistSubscribed,
  });

  factory SearchPlaylistModel.fromJson(Map<String, dynamic> json) {
    return SearchPlaylistModel(
      playlistId: json['playlist_id'],
      playlistName: json['playlist_name'],
      playlistChannelName: json['playlist_channel'],
      playlistChannelId: json['playlist_channel_id'],
      playlistPic: json['playlist_thumbnail'],
      playlistSubscribed: json['playlist_subscribed'],
    );
  }


  static List<SearchPlaylistModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> data = json['results']?['playlist_results'] ?? [];
    return data.map((item) => SearchPlaylistModel.fromJson(item)).toList();
  }
}