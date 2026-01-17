class PingModel {
  final String response;


  PingModel({
    required this.response,
  });

  factory PingModel.fromJson(Map<String, dynamic> json) {
    return PingModel(
      response: json['response'],
    );
  }
}