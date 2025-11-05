class SponsorBlockSegment {
  final String actionType;
  final double videoDuration;
  final List<double> segment;
  final int votes;
  final String category;
  final String uuid;
  final int locked;

  SponsorBlockSegment({
    required this.actionType,
    required this.videoDuration,
    required this.segment,
    required this.votes,
    required this.category,
    required this.uuid,
    required this.locked,
  });

  factory SponsorBlockSegment.fromJson(Map<String, dynamic> json) {
    return SponsorBlockSegment(
      actionType: json['actionType'],
      videoDuration: json['videoDuration'],
      segment: List<double>.from(json['segment'].map((x) => x.toDouble())),
      votes: json['votes'],
      category: json['category'],
      uuid: json['UUID'],
      locked: json['locked'],
    );
  }
}

class SponsorBlock {
  final bool isEnabled;
  final int lastRefresh;
  final bool hasUnlocked;
  final List<SponsorBlockSegment> segments;

  SponsorBlock({
    required this.isEnabled,
    required this.lastRefresh,
    required this.hasUnlocked,
    required this.segments,
  });

  factory SponsorBlock.fromJson(Map<String, dynamic> json) {
    return SponsorBlock(
      isEnabled: json['is_enabled'] ?? false,
      lastRefresh: json['last_refresh'] ?? 0,
      hasUnlocked: json['has_unlocked'] ?? false,
      segments: json['segments'] != null
          ? List<SponsorBlockSegment>.from(
              json['segments'].map((x) => SponsorBlockSegment.fromJson(x)))
          : [],
    );
  }
}
