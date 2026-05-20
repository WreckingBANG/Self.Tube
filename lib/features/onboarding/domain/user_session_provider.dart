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

}

final userSessionProvider = AsyncNotifierProvider<UserSessionNotifier, bool> (
  UserSessionNotifier.new
);
