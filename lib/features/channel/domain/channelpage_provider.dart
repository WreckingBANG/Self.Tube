import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final channelPageProvider = FutureProvider.family((ref, String id) async {
  return ChannelApi().fetchChannel(id);
});


final channelActionsProvider = Provider((ref) {
  return ChannelActions(ref);
});

class ChannelActions {
  final Ref ref;
  ChannelActions(this.ref);

  Future<void> toggleSubscription(String id, bool subscribe) async {
    await ChannelApi().modifyChannel(id, subscribe);
    ref.invalidate(channelPageProvider(id));
  }
}
