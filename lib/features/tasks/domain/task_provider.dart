import 'dart:async';
import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:Self.Tube/features/tasks/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TaskNotifier extends AsyncNotifier<List<TaskModel>?> with WidgetsBindingObserver{
  Timer? _timer;
  
  @override
  Future<List<TaskModel>?> build() async {
    WidgetsBinding.instance.addObserver(this);
    _startPolling();

    ref.onDispose((){
      WidgetsBinding.instance.removeObserver(this);
    });

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
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _startPolling();
    }
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
