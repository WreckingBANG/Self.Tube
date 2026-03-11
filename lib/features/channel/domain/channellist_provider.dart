import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelListNotifier extends AsyncNotifier<List?> {
  ChannelListNotifier(this.query);
  late final query;
  int currentPage = 1;
  bool hasMore = true;
  
  @override
  Future<List?> build() async {
    final channels = await ChannelApi().fetchChannelList("$query&page=$currentPage");
    
    if (channels != null) {
      if (currentPage >= channels.lastPage) {
        hasMore = false;
      }

      return channels.data; 
    }
    return []; 
  }
  
  Future<void> refresh() async {
    hasMore = true;
    currentPage = 1;
    ref.invalidateSelf();
  }

  Future<void> fetchNext() async {
    final current = state.value!; 

    currentPage++;

    final newPage = await ChannelApi().fetchChannelList("$query&page=$currentPage");
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

  Future<void> addChannel(String id) async {
    await ChannelApi().addChannel(id);
    //To-Do: Send user to ActionsScreen
  }

  Future<void> deleteChannel(String id) async {
    final current = state.value!;
    await ChannelApi().deleteChannel(id);

    final modified = current.where((c) => c.channelId != id).toList();

    state = AsyncData(modified);
  }
  
}


final channelListProvider = AsyncNotifierProvider.family<ChannelListNotifier, List?, String> (
    ChannelListNotifier.new,
);
