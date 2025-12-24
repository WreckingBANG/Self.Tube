import '../settings_service.dart';

class ApiHeaders {
  static Map<String, String> authHeaders() {
    final apiTokenAuth = SettingsService.apiTokenAuth;
    final apiToken = SettingsService.apiToken;
    final sessionToken = SettingsService.sessionToken;
    final csrfToken = SettingsService.csrfToken;

    return {
      'Content-Type': 'application/json',
      if (apiTokenAuth == true)
        'Authorization': 'token $apiToken',
      if (apiTokenAuth != true)
        'Cookie': 'sessionid=$sessionToken; csrftoken=$csrfToken',
        'X-CSRFToken': '$csrfToken',
    };
  }
}
