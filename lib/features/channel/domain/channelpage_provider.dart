import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:Self.Tube/features/channel/data/models/channel_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChannelPageNotifier extends AsyncNotifier<ChannelItemModel?> {
  ChannelPageNotifier(this.id);
  late final String id;
  
  @override
  Future<ChannelItemModel?> build() async {
    return ChannelApi().fetchChannel(id);
  }

  Future<void> subscribe(bool val) async {
    await AsyncValue.guard(() => ChannelApi().modifyChannel(id, val));
    state = await AsyncValue.guard(() => ChannelApi().fetchChannel(id));
  }

}

final channelPageProvider = AsyncNotifierProvider.family<ChannelPageNotifier, ChannelItemModel?, String>(
  ChannelPageNotifier.new,
);

