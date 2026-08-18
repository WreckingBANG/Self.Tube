class PingModel {
  final String response;
  final String version;
  final bool hasUpdate;
  final String updateVersion;


  PingModel({
    required this.response,
    required this.version,
    this.hasUpdate = false,
    this.updateVersion = "",
  });

  factory PingModel.fromJson(Map<String, dynamic> json) {
    return PingModel(
      response: json['response'],
      version: json['version'],
      hasUpdate: json['ta_update']?['status'] ?? false,
      updateVersion: json['ta_update']?['version'] ?? "",
    );
  }
}
