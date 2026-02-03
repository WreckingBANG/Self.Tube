class TaskModel {
  final String taskId;
  final String title;
  final String group;
  final bool start;
  final bool stop;
  final String level;
  final List<String> messages;
  final double progress;
  final String? command;

  TaskModel({
    required this.taskId,
    required this.title,
    required this.group,
    required this.start,
    required this.stop,
    required this.level,
    required this.messages,
    required this.progress,
    required this.command,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['id'] ?? '',
      title: json['title'] ?? '',
      group: json['group'] ?? '',
      start: json['api_start'] ?? false,
      stop: json['api_stop'] ?? false,
      level: json['level'] ?? '',
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      progress: (json['progress'] ?? 0.0).toDouble(),
      command: json['command'],
    );
  }

  static List<TaskModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => TaskModel.fromJson(item)).toList();
  }
}
