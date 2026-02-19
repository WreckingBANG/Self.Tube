class ChannelListItemModel {
  final String channelId;
  final String channelName;
  final String profilePic;
  final int subscribers;
  final bool subscribed;

  ChannelListItemModel({
    required this.channelId,
    required this.channelName,
    required this.profilePic,
    required this.subscribers,
    required this.subscribed,
  });

  factory ChannelListItemModel.fromJson(Map<String, dynamic> json) {
    return ChannelListItemModel(
      channelId: json['channel_id'] ?? '',
      channelName: json['channel_name'] ?? '',
      profilePic: json['channel_thumb_url'] ?? '',
      subscribers: json['channel_subs'] ?? 0,
      subscribed: json['channel_subscribed'] ?? false,
    );
  }

  static List<ChannelListItemModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'];
    return data.map((item) => ChannelListItemModel.fromJson(item)).toList();
  }
}
