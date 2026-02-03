import 'dart:convert';
import 'package:Self.Tube/features/tasks/data/models/queue_wrapper_model.dart';
import 'package:Self.Tube/common/data/services/api/api_service.dart';
import 'package:Self.Tube/features/tasks/data/models/task_model.dart';

class TaskApi {
  Future<QueueWrapperModel?> fetchQueue(String options) {
    return ApiService.request(
      url: '/api/download/?filter=pending',
      method: 'GET',
      parser: (json) => QueueWrapperModel.fromJson(json),
    );
  }

  Future<List<TaskModel>?> fetchTasks() {
    return ApiService.request(
      url: '/api/notification/',
      method: 'GET',
      parser: (json) {
        final List<dynamic> list = json;
        return list.map((item) => TaskModel.fromJson(item)).toList();
      },
    );
  }

  Future<bool?> addVideo(String id) {
    return ApiService.request(
      url: '/api/download/',
      method: 'POST',
      body: json.encode({
        "data": [
          {
            "youtube_id": id,
            "status": "pending"
          }
        ]
      }),
      parser: (_) => true,
    );
  }

  Future<bool?> changeVideoQueueStatus(String id, String status) {
    return ApiService.request(
      url: '/api/download/$id/',
      method: 'POST',
      body: json.encode({
        "status": status,
      }),
      parser: (_) => true,
    );
  }

  Future<bool?> deleteSingleVideoQueue(String id) {
    return ApiService.request(
      url: '/api/download/$id/',
      method: 'DELETE',
      parser: (_) => true,
    );
  }

  Future<bool?> rescanSubscriptions() {
    return ApiService.request(
      url: '/api/task/by-name/update_subscribed/',
      method: 'POST',
      parser: (_) => true,
    );
  }

  Future<bool?> startDownloads() {
    return ApiService.request(
      url: '/api/task/by-name/download_pending/',
      method: 'POST',
      parser: (_) => true,
    );
  }

}
