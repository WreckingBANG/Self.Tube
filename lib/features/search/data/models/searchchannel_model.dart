class SearchChannelModel {
  final String channelId;
  final String channelName;
  final String channelDescription;
  final String profilePic;
  final String banner;
  final int subscribers;
  final bool subscribed;

  SearchChannelModel({
    required this.channelId,
    required this.channelName,
    required this.channelDescription,
    required this.profilePic,
    required this.banner,
    required this.subscribers,
    required this.subscribed,
  });

  factory SearchChannelModel.fromJson(Map<String, dynamic> json) {
    return SearchChannelModel(
      channelId: json['channel_id'] ?? '',
      channelName: json['channel_name'] ?? '',
      channelDescription: json['channel_description'] ?? '',
      profilePic: json['channel_thumb_url'] ?? '',
      banner: json['channel_banner_url'] ?? '',
      subscribers: (json['channel_subs'] as num?)?.toInt() ?? 0,
      subscribed: json['channel_subscribed'] ?? false,
    );
  }


  static List<SearchChannelModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> data = json['results']?['channel_results'] ?? [];
    return data.map((item) => SearchChannelModel.fromJson(item)).toList();
  }
}