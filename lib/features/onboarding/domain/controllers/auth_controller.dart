import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/features/onboarding/data/api/user_api.dart';

class AuthController {
  Future<bool> login(bool usesApiToken, String url, String username, String password, String apiToken) async {
    if (usesApiToken){
      try {
        final ping = await UserApi().testConnectionToken(url, apiToken);
        if (ping?.response == 'pong'){
          await SettingsService.setApiTokenAuth(true);
          await SettingsService.setInstanceUrl(url);
          await SettingsService.setApiToken(apiToken);
          await SettingsService.setDoneSetup(true);
          return true;
        }
      } catch (e) {
        return false;
      } 
    } else {
      try {
        final response = await UserApi().fetchSession(url, username, password);
        if (response?.sessionToken != null && response?.csrfToken != null){
          final ping = await UserApi().testConnectionSession(
            url, 
            response!.sessionToken, 
            response.csrfToken
          );
          if (ping?.response == 'pong') {
            await SettingsService.setInstanceUrl(url);
            await SettingsService.setSessionToken(response.sessionToken);
            await SettingsService.setCSRFToken(response.csrfToken);
            await SettingsService.setApiTokenAuth(false);
            await SettingsService.setDoneSetup(true);
            return true;
          }
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await SettingsService.setDoneSetup(false);
      await SettingsService.setInstanceUrl("");
      await SettingsService.setApiToken("");

      return true;
    } catch (e) {
      return false;
    }
  }
}
