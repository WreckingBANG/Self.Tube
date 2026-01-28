import 'dart:convert';
import 'package:Self.Tube/common/data/services/api/api_service.dart';
import 'package:Self.Tube/features/channel/data/models/channel_model.dart';
import 'package:Self.Tube/features/channel/data/models/channellist_wrapper_model.dart';

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

  Future<bool?> addChannel(String id) {
    return ApiService.request(
      url: '/api/channel/',
      method: 'POST',
      body: json.encode({
        "data": [
          {
            "channel_id": id,
            "channel_subscribed": "true"
          }
        ]
      }),
      parser: (_) => true,
    );
  }

  Future<bool?> modifyChannel(String id, bool subscribed) {
    return ApiService.request(
      url: '/api/channel/$id/',
      method: 'POST',
      body: json.encode({
        "channel_subscribed": subscribed
      }),
      parser: (_) => true,
    );
  }

  Future<bool?> deleteChannel(String id) {
    return ApiService.request(
      url: '/api/channel/$id/',
      method: 'DELETE',
      parser: (_) => true,
    );
  }
}
