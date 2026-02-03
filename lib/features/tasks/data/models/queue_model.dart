class QueueItemModel {
  final String youtubeId;
  final String title;
  final String channelId;
  final String channelName;
  final String thumbnail;
  final String durationStr;
  final String videoDate;

  QueueItemModel({
    required this.youtubeId,
    required this.title,
    required this.channelId,
    required this.channelName,
    required this.thumbnail,
    required this.durationStr,
    required this.videoDate
  });

  factory QueueItemModel.fromJson(Map<String, dynamic> json) {
    return QueueItemModel(
      youtubeId: json['youtube_id'] ?? '',
      title: json['title'] ?? '',
      channelId: json['channel_id'] ?? '',
      channelName: json['channel_name'] ?? '',
      thumbnail: json['vid_thumb_url'] ?? '',
      durationStr: json['duration'] ?? '',
      videoDate: json['published'],
    );
  }


  static List<QueueItemModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'];
    return data.map((item) => QueueItemModel.fromJson(item)).toList();
  }
}
