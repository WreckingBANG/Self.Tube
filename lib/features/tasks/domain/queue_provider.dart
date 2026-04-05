import 'dart:async';
import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueueNotifier extends AsyncNotifier<List?> with WidgetsBindingObserver{
  QueueNotifier(this.query);
  Timer? _timer;
  late final query;
  int currentPage = 1;
  bool hasMore = true;

  @override
  Future<List?> build() async {
    WidgetsBinding.instance.addObserver(this);
    _startPolling();

    ref.onDispose((){
      WidgetsBinding.instance.removeObserver(this);
    });

    final videos = await TaskApi().fetchQueue("$query&page=$currentPage");

    if (videos != null) {
      if (currentPage >= videos.lastPage) {
        hasMore = false;
      }

      return videos.data;
    }
    
    return [];
  }

  void _startPolling() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
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
    hasMore = true;
    currentPage = 1;
    ref.invalidateSelf();
  }

  Future<void> fetchNext() async {
    final current = state.value!;

    currentPage++;

    final newPage = await TaskApi().fetchQueue("$query&page=$currentPage");
    if (newPage != null) {
      if (currentPage >= newPage.lastPage) {
        hasMore = false;
      }

      final merged = [
        ...current,
        ...newPage.data,
      ];

      state = AsyncData(merged);
    }
  }

  Future<void> deleteVideo(String id) async {
    final current = state.value!;
    await TaskApi().deleteSingleVideoQueue(id);

    final modified = current.where((v) => v.videoId != id).toList();

    state = AsyncData(modified);
  }
}

final queueProvider = AsyncNotifierProvider.autoDispose.family<QueueNotifier, List?, String> (
  QueueNotifier.new,
);
