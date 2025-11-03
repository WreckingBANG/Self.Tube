class VideoListItemModel {
  final String youtubeId;
  final String title;
  final String channelId;
  final String channelName;
  final String thumbnail;
  final int duration;
  final String durationStr;
  final bool watched;
  final double progress;
  final double position;
  final String videoDate;

  VideoListItemModel({
    required this.youtubeId,
    required this.title,
    required this.channelId,
    required this.channelName,
    required this.thumbnail,
    required this.duration,
    required this.durationStr,
    required this.watched,
    required this.progress,
    required this.position,
    required this.videoDate
  });

  factory VideoListItemModel.fromJson(Map<String, dynamic> json) {
    return VideoListItemModel(
      youtubeId: json['youtube_id'] ?? '',
      title: json['title'] ?? '',
      channelId: json['channel']?['channel_id'] ?? '',
      channelName: json['channel']?['channel_name'] ?? '',
      thumbnail: json['vid_thumb_url'] ?? '',
      duration: (json['player']?['duration'] as num?)?.toInt() ?? 0,
      durationStr: json['player']?['duration_str'] ?? '',
      watched: json['player']?['watched'] ?? false,
      progress: (json['player']?['progress'] as num?)?.toDouble() ?? 0.0,
      position: (json['player']?['position'] as num?)?.toDouble() ?? 0.0,
      videoDate: json['published'],
    );
  }


  static List<VideoListItemModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'];
    return data.map((item) => VideoListItemModel.fromJson(item)).toList();
  }
}