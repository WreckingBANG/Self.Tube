class PlaylistListItemModel {
  final String playlistId;
  final String playlistName;
  final String playlistChannelName;
  final String playlistChannelId;
  final String playlistPic;
  final bool playlistSubscribed;

  PlaylistListItemModel({
    required this.playlistId,
    required this.playlistName,
    required this.playlistChannelName,
    required this.playlistChannelId,
    required this.playlistPic,
    required this.playlistSubscribed,
  });

  factory PlaylistListItemModel.fromJson(Map<String, dynamic> json) {
    return PlaylistListItemModel(
      playlistId: json['playlist_id'],
      playlistName: json['playlist_name'],
      playlistChannelName: json['playlist_channel'],
      playlistChannelId: json['playlist_channel_id'],
      playlistPic: json['playlist_thumbnail'],
      playlistSubscribed: json['playlist_subscribed'],
    );
  }

  static List<PlaylistListItemModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'];
    return data.map((item) => PlaylistListItemModel.fromJson(item)).toList();
  }
}