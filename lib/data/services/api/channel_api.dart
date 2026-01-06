import 'api_service.dart';
import 'package:Self.Tube/data/models/channel/channel_model.dart';
import 'package:Self.Tube/data/models/channel/channellist_wrapper_model.dart';

class ChannelApi {
  Future<ChannelItemModel?> fetchChannel(String id) {
    return ApiService.request(
      url: '/api/channel/$id',
      method: 'GET',
      parser: (json) => ChannelItemModel.fromJson(json),
    );
  } 

  Future<ChannelListWrapperModel?> fetchChannelList(String options) {
    return ApiService.request(
      url: '/api/channel$options',
      method: 'GET',
      parser: (json) => ChannelListWrapperModel.fromJson(json),
    );
  } 
}