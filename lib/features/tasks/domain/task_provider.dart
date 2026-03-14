import 'dart:async';
import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:Self.Tube/features/tasks/data/models/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TaskNotifier extends AsyncNotifier<List<TaskModel>?> {
  Timer? _timer;
  
  @override
  Future<List<TaskModel>?> build() async {
    _startPolling();   

    return await TaskApi().fetchTasks();
  }

  void _startPolling() {
    _timer?.cancel();
    
    _timer = Timer.periodic(Duration(seconds: 2), (_) async {
      await refresh();
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

  }

  Future<void> refresh() async {
    final current = state.value!;

    final tasks = await TaskApi().fetchTasks();

    if (tasks != current) {
      state = AsyncData(tasks);
    }
  }

} 

final taskProvider = AsyncNotifierProvider.autoDispose<TaskNotifier, List<TaskModel>?>(
  TaskNotifier.new,
);
