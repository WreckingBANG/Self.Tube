import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Self.Tube/common/data/services/api/api_headers.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/global_snackbar.dart';
import 'package:Self.Tube/app/logging/talker.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static String? baseUrl = SettingsService.instanceUrl;

  static void Function()? onSessionExpired;

  static Future<T?> request<T>({
    required String url,
    required String method,
    bool showError = true,
    String? baseUrl,
    Map<String, String>? headers,
    bool decodeJson = true,
    Object? body,
    required T Function(dynamic json) parser,
  }) async {
    
    talker.info("API Request: $method $url");

    try {
      late http.Response response;
      headers ??= ApiHeaders.authHeaders();
      baseUrl ??= SettingsService.instanceUrl;

      switch (method) {
        case 'GET':
          response = await http.get(Uri.parse('$baseUrl$url'), headers: headers);
          break;
        case 'POST':
          response = await http.post(Uri.parse('$baseUrl$url'), headers: headers, body: body);
          break;
        case 'PUT':
          response = await http.put(Uri.parse('$baseUrl$url'), headers: headers, body: body);
          break;
        case 'PATCH':
          response = await http.patch(Uri.parse('$baseUrl$url'), headers: headers, body: body);
          break;
        case 'DELETE':
          response = await http.delete(Uri.parse('$baseUrl$url'), headers: headers, body: body);
          break;
        default: 
          throw UnsupportedError('HTTP method not supported: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        talker.log("API Response: $method | $url | ${response.statusCode}");
      } else if (response.statusCode >= 300 && response.statusCode < 400) {
        talker.warning("API Redirecting");
      } else if ((response.statusCode == 401 || response.statusCode == 403) && response.body.contains("Authentication credentials were not provided")) {
        talker.warning("Session expired, redirecting to login");
        GlobalSnackbar.show(
          "Session expired",
          icon: Icons.error_outline,
          iconColor: Colors.red,
          autoDismiss: false
        );
        onSessionExpired?.call(); 
      } else { 
        talker.error("API Response: $method | $url | ${response.statusCode} \nBody: ${response.body}");
      }

      if (response.statusCode >= 200 && response.statusCode < 400) {
        if (!decodeJson) {
           return parser(response);
        } 
        if (response.body.isEmpty) { 
          return parser(null); 
        } 
        final jsonData = jsonDecode(response.body); 
        return parser(jsonData);
      }

      throw Exception('HTTP ${response.statusCode}: ${response.body}'); 

    } catch (e) {
      if (showError) {
        GlobalSnackbar.show(
          "$e",
          icon: Icons.error_outline,
          iconColor: Colors.red,
          autoDismiss: false
        );
      }
      throw Exception("Network error: $e");
    }
  }
}
