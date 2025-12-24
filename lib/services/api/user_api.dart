import 'dart:convert';

import 'package:Self.Tube/models/user/ping_model.dart';
import 'package:Self.Tube/models/user/session_model.dart';
import 'package:Self.Tube/models/user/userinfo_model.dart';
import 'api_service.dart';

class UserApi {
  Future<UserInfoModel?> fetchUserModel() {
    return ApiService.request(
      url: '/api/user/account/',
      method: 'GET',
      parser: (json) => UserInfoModel.fromJson(json),
    );
  }

  Future<PingModel?> testConnectionSession(String tBaseUrl, String tSessionToken, String tCSRFToken) {
    return ApiService.request(
      baseUrl: tBaseUrl,
      url: '/api/ping',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'sessionid=$tSessionToken',
        'X-CSRFToken': tCSRFToken
      },
      method: 'GET',
      parser: (json) => PingModel.fromJson(json),
    );
  }

  Future<PingModel?> testConnectionToken(String tBaseUrl, String tApiToken) {
    return ApiService.request(
      baseUrl: tBaseUrl,
      url: '/api/ping',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $tApiToken',
      },
      method: 'GET',
      parser: (json) => PingModel.fromJson(json),
    );
  }

  Future<SessionResponseModel?> fetchSession(String tBaseUrl, String tUsername, String tPassword){
    return ApiService.request<SessionResponseModel?>(
      baseUrl: tBaseUrl,
      url: '/api/user/login/',
      method: 'POST',
      decodeJson: false,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'username': tUsername,
        'password': tPassword,
        'remember_me': 'on',
      }),
      parser: (response) { 
        final setCookie = response.headers['set-cookie']; 
        if (setCookie != null) { 
          return SessionResponseModel.fromCookies(setCookie); 
        } 
        return null;
      },
    );
  }
}