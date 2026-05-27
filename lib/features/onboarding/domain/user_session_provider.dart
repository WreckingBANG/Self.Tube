import 'package:Self.Tube/features/onboarding/domain/controllers/auth_controller.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSessionNotifier extends AsyncNotifier<bool> {

  @override
  Future<bool> build() async {
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

  Future<void> logout() async {
    AuthController().logout; 
    state = AsyncData(false); 
  }

}

final userSessionProvider = AsyncNotifierProvider<UserSessionNotifier, bool> (
  UserSessionNotifier.new
);
