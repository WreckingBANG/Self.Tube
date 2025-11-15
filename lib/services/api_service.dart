import 'dart:convert';
import 'package:Self.Tube/models/userinfo_model.dart';
import 'package:http/http.dart' as http;
import '../models/videolist_model.dart';
import '../models/videolist_similar_model.dart';
import '../models/videoplayer_model.dart';
import '../models/channellist_model.dart';
import '../models/search/searchwrapper_model.dart';
import '../models/commentlist_model.dart';
import '../models/playlistlist_model.dart';
import '../services/settings_service.dart';
import '../models/ping_model.dart';
import '../models/channel_model.dart';

class ApiService {

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  static Future<PingModel?> testConnection(String tApiToken, String tBaseUrl) async {
    try {
      final response = await http.get(
          Uri.parse('$tBaseUrl/api/ping'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $tApiToken',
          },
        );
      if (response.statusCode == 200) {
        return PingModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<VideoListItemModel>?> fetchVideoList(String options) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/video$options'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        return VideoListItemModel.fromJsonList(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<VideoListSimilarItemModel>?> fetchSimilarVideoList(videoId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/video/$videoId/similar'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        return VideoListSimilarItemModel.fromJsonList(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<VideoPlayerModel?> fetchVideoPlayer(String videoId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/video/$videoId'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        return VideoPlayerModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<ChannelListItemModel>?> fetchChannelList() async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/channel/?filter=subscribed'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        return ChannelListItemModel.fromJsonList(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<ChannelItemModel?> fetchChannel(String channelId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/channel/$channelId'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        return ChannelItemModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<List<PlaylistListItemModel>?> fetchPlaylistList() async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/playlist'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        return PlaylistListItemModel.fromJsonList(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<bool> setVideoProgress(String videoId, int position) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/video/$videoId/progress/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $apiToken',
        },
        body: json.encode({'position': position}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to set video progress: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> setVideoWatched(String videoId, bool watched) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/watched/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $apiToken',
        },
        body: json.encode({
          "id": videoId,
          'is_watched': watched
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to set video progress: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<List<CommentListItemModel>?> fetchCommentList(String videoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/video/$videoId/comment/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token $apiToken',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        return CommentListItemModel.fromJsonList(jsonData);
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<UserInfoModel?> fetchUserModel() async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/user/account/'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        return UserInfoModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<SearchWrapperModel?> fetchSearch(String query) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/search/?query=$query'),
          headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $apiToken',
          },
        );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return SearchWrapperModel.fromJson(jsonBody);
      } else {
        throw Exception(response);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


}