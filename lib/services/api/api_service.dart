import 'dart:convert';
import 'package:Self.Tube/services/api/api_headers.dart';
import 'package:Self.Tube/services/settings_service.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static String? baseUrl = SettingsService.instanceUrl;

  static Future<T?> request<T>({
    required String url,
    required String method,
    String? baseUrl,
    Map<String, String>? headers,
    bool decodeJson = true,
    Object? body,
    required T Function(dynamic json) parser,
  }) async {
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
        if (!decodeJson) {
           return parser(response);
        } 
        if (response.body.isEmpty) { 
          return parser(null); 
        } 
        final jsonData = jsonDecode(response.body); 
        return parser(jsonData);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) { 
        return parser(response); 
      } else { 
        throw Exception('HTTP ${response.statusCode}: ${response.body}'); 
      }
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }
}