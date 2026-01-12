class ChannelItemModel {
  final String channelId;
  final String channelName;
  final String profilePic;
  final int subscribers;
  final bool subscribed;
  final String banner;
  final String description;

  ChannelItemModel({
    required this.channelId,
    required this.channelName,
    required this.profilePic,
    required this.subscribers,
    required this.subscribed,
    required this.banner,
    required this.description,
  });

  factory ChannelItemModel.fromJson(Map<String, dynamic> json) {
    return ChannelItemModel(
      channelId: json['channel_id'],
      channelName: json['channel_name'],
      profilePic: json['channel_thumb_url'],
      subscribers: json['channel_subs'],
      subscribed: json['channel_subscribed'],
      banner: json['channel_banner_url'],
      description: json['channel_description']
    );
  }
}