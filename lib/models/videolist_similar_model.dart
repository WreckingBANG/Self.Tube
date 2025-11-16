class VideoListSimilarItemModel {
  final String youtubeId;
  final String title;
  final String channelName;
  final String channelThumb;
  final String thumbnail;
  final int duration;
  final String durationStr;
  final int views;
  final bool watched;
  final double progress;
  final double position;
  final String videoDate;


  VideoListSimilarItemModel({
    required this.youtubeId,
    required this.title,
    required this.channelName,
    required this.channelThumb,
    required this.thumbnail,
    required this.duration,
    required this.durationStr,
    required this.views,
    required this.watched,
    required this.progress,
    required this.position,
    required this.videoDate
  });

  factory VideoListSimilarItemModel.fromJson(Map<String, dynamic> json) {
    return VideoListSimilarItemModel(
      youtubeId: json['youtube_id'] ?? '',
      title: json['title'] ?? '',
      channelName: json['channel']?['channel_name'] ?? '',
      channelThumb: json['channel']?['channel_thumb_url']?? '',
      thumbnail: json['vid_thumb_url'] ?? '',
      duration: (json['player']?['duration'] as num?)?.toInt() ?? 0,
      durationStr: json['player']?['duration_str'] ?? '',
      views: json['stats']['view_count'] ?? '',
      watched: json['player']?['watched'] ?? false,
      progress: (json['player']?['progress'] as num?)?.toDouble() ?? 0.0,
      position: (json['player']?['position'] as num?)?.toDouble() ?? 0.0,
      videoDate: json['published'],
    );
  }


  static List<VideoListSimilarItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => VideoListSimilarItemModel.fromJson(item)).toList();
  }
}