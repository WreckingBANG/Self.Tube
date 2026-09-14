import 'dart:async';
import 'package:Self.Tube/common/domain/pagination_mixin.dart';
import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueueNotifier extends AsyncNotifier<List?> with WidgetsBindingObserver, PaginationMixin{
  QueueNotifier(this.query);
  Timer? _timer;
  late final String query;

  @override
  Future<List?> build() async {
    WidgetsBinding.instance.addObserver(this);
    _startPolling();

    ref.onDispose((){
      WidgetsBinding.instance.removeObserver(this);
    });
    
    if (pagination.filter.isEmpty) {
      pagination.filter = "&filter=pending";
    }

    final result = await getData();

    if (result.hasError == false) {
      return result.data;
    }
    
    return [];
  }

  @override 
  Future<PageResult> apiLoader(String query) async {
     
    final result  = await TaskApi().fetchQueue(query);
    
    if (result == null) {
      return PageResult(hasError: true);
    }

    return PageResult(
      data: result.data, 
      lastPage: result.lastPage
    ); 
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
  
  @override
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> changeHidden(bool value) async {
    if (value) {
      pagination.filter = "&filter=ignore";
      pagination.currentPage = 1;
    } else {
      pagination.filter = "&filter=pending";
      pagination.currentPage = 1;
    }
    refresh();
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
