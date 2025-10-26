class VideoPlayerModel {
  final String videoId;
  final String videoTitle;
  final String channelName;
  final bool channelSubscribed;
  final int channelSubCount;
  final String channelThumbUrl;
  final String channelId;
  final String videoThumbnail;
  final String videoDate;
  final String videoUrl;
  final int videoLikeCount;
  final int videoDislikeCount;
  final int videoViewCount;
  final String videoDescription;
  final double videoPosition;

  VideoPlayerModel({
    required this.videoId,
    required this.videoTitle,
    required this.channelName,
    required this.channelSubscribed,
    required this.channelSubCount,
    required this.channelThumbUrl,
    required this.channelId,
    required this.videoThumbnail,
    required this.videoUrl,
    required this.videoDate,
    required this.videoLikeCount,
    required this.videoDislikeCount,
    required this.videoViewCount,
    required this.videoDescription,
    required this.videoPosition,
  });

  factory VideoPlayerModel.fromJson(Map<String, dynamic> json) {
    return VideoPlayerModel(
      videoId: json['youtube_id'],
      videoTitle: json['title'],
      channelName: json['channel']['channel_name'],
      channelSubscribed: json['channel']['channel_subscribed'],
      channelSubCount: json['channel']['channel_subs'],
      channelThumbUrl: json['channel']['channel_thumb_url'],
      channelId: json['channel']['channel_id'],
      videoThumbnail: json['vid_thumb_url'],
      videoUrl: json['media_url'],
      videoDate: json['published'],
      videoLikeCount: json['stats']['like_count'],
      videoDislikeCount: json['stats']['dislike_count'],
      videoViewCount: json['stats']['view_count'],
      videoDescription: json['description'],
      videoPosition: (json['player']?['position'] ?? 0.0).toDouble(),
    );
  }
}