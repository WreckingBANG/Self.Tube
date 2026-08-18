import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/features/onboarding/data/api/user_api.dart';
import 'package:Self.Tube/features/onboarding/data/models/ping_model.dart';
import 'package:Self.Tube/features/onboarding/data/models/userinfo_model.dart';


class UserSession {
  static bool isPrivileged = false;
  static UserInfoModel? user;
  static PingModel? ping;

  static Future<void> init() async {
    if (SettingsService.doneSetup == true) {
      ping = await UserApi().testConnection();
      user = await UserApi().fetchUserModel();
      isPrivileged = user != null && (user!.isStaff || user!.isSuperUser);
    }
  }
}

