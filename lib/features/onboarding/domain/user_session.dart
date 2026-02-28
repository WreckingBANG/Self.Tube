import 'package:Self.Tube/features/onboarding/data/api/user_api.dart';
import 'package:Self.Tube/features/onboarding/data/models/userinfo_model.dart';


class UserSession {
  static bool isPrivileged = false;
  static UserInfoModel? user;

  static Future<void> init() async {
    user = await UserApi().fetchUserModel();

    isPrivileged = user != null && (user!.isStaff || user!.isSuperUser);
  }
}

