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
    print("triggered");
    print(state);
  }


}

final selectionProvider = NotifierProvider.family<SelectionNotifier, List<String>, String> (
  SelectionNotifier.new,
);
