import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:Self.Tube/features/videos/domain/videolist_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionNotifier extends Notifier<List<String>> {
  SelectionNotifier(this.query);
  late final query;

  @override
  List<String> build() {
    return [];
  }

  bool contains(String id) {
    return state.contains(id);
  }

  void toggle(String videoId) {
    if (state.contains(videoId)) {
      state = state.where((id) => id != videoId).toList(); 
    } else {
      state = [...state, videoId]; 
    }
  }
  
  void clear() {
    state = [];
  }

  void setWatched(bool value) async {
    final p = ref.read(videoListProvider(query).notifier);
    for (final video in state) {
      await p.setWatched(value, video);
      toggle(video);
    }  
  }

  void deleteVideos() async {
    final p = ref.read(videoListProvider(query).notifier);
    for (final video in state) {
      await p.deleteVideo(video);
      toggle(video);
    }  
  } 
  
  void redownloadVideos() async {
    for (final video in state) {
      await TaskApi().addVideo(video, "?autostart=true&force=true");
      toggle(video);
    }
  }

}

final selectionProvider = NotifierProvider.family<SelectionNotifier, List<String>, String> (
  SelectionNotifier.new,
);
