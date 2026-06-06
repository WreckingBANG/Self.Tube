import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/api/api_service.dart';
import 'package:Self.Tube/features/onboarding/domain/controllers/auth_controller.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSessionNotifier extends AsyncNotifier<bool> {

  @override
  Future<bool> build() async {

    ApiService.onSessionExpired = () {
      resetLoginSettings();
    };

    try {
      await UserSession.init();
      return true;
    } catch (e) {
      return false; 
    }
  }

  Future<void> refresh() async {
    bool result = false;
    try {
      await UserSession.init();
      result = true;
    } catch (e) {
      result = false; 
    }
    state = AsyncData(result);
  }

  Future<void> resetLoginSettings() async {
    AuthController().resetLoginSettings();
    AppRouter.navigatorKey.currentState?.pushNamed(
      AppRouter.onboardingLogin
    );
    state = AsyncData(false); 
  }

  Future<void> logout() async {
    AuthController().logout();
    state = AsyncData(false); 
  }

}

final userSessionProvider = AsyncNotifierProvider<UserSessionNotifier, bool> (
  UserSessionNotifier.new
);
