import 'package:Self.Tube/common/domain/pagination_mixin.dart';
import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelListNotifier extends AsyncNotifier<List?> with PaginationMixin{
  ChannelListNotifier(this.query);
  late final String query;
  
  @override
  Future<List?> build() async {
    final isLoggedIn = ref.watch(userSessionProvider).value ?? false;

    if (!isLoggedIn) {
      pagination.currentPage = 1;
      pagination.hasMore = true;
      return [];
    }

    final result = await getData(); 
    
    if (result.data != null) {
      return result.data; 
    }
    
    return []; 
  }

  Future<PageResult> apiLoader(String query) async {
    
    final result = await ChannelApi().fetchChannelList(query);

    if (result == null) {
      return PageResult(hasError: true);
    }

    return PageResult(
      data: result.data,
      lastPage: result.lastPage
    );
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
