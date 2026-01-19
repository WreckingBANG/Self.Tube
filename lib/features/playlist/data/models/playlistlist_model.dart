class PlaylistListItemModel {
  final String playlistId;
  final String playlistName;
  final String playlistChannelName;
  final String playlistChannelThumbUrl;
  final String playlistChannelId;
  final String playlistPic;
  final String playlistType;
  final bool playlistSubscribed;

  PlaylistListItemModel({
    required this.playlistId,
    required this.playlistName,
    required this.playlistChannelName,
    required this.playlistChannelThumbUrl,
    required this.playlistChannelId,
    required this.playlistPic,
    required this.playlistType,
    required this.playlistSubscribed,
  });

  factory PlaylistListItemModel.fromJson(Map<String, dynamic> json) {
    return PlaylistListItemModel(
      playlistId: json['playlist_id'] ?? '',
      playlistName: json['playlist_name'],
      playlistChannelName: json['playlist_channel'] ?? '',
      playlistChannelThumbUrl: json['channel_thumb_url'] ?? '',
      playlistChannelId: json['playlist_channel_id'] ?? '',
      playlistPic: json['playlist_thumbnail'] ?? '',
      playlistType: json['playlist_type'],
      playlistSubscribed: json['playlist_subscribed'] ?? '',
    );
  }

  static List<PlaylistListItemModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'];
    return data.map((item) => PlaylistListItemModel.fromJson(item)).toList();
  }
}