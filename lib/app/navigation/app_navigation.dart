import 'package:Self.Tube/app/ui/about/about_screen.dart';
import 'package:Self.Tube/features/channel/ui/screens/channelpage_screen.dart';
import 'package:Self.Tube/features/onboarding/ui/screens/login_screen.dart';
import 'package:Self.Tube/features/playlist/ui/screens/playlistpage_screen.dart';
import 'package:Self.Tube/features/settings/ui/screens/appearance_settings_screen.dart';
import 'package:Self.Tube/features/settings/ui/screens/overview_settings_screen.dart';
import 'package:Self.Tube/features/settings/ui/screens/player_settings_screen.dart';
import 'package:Self.Tube/features/settings/ui/screens/sponsorblock_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/app/ui/shell/homecontainer_screen.dart';
import 'package:Self.Tube/features/onboarding/ui/screens/privacypolicy_screen.dart';

class AppRouter {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const onboardingLogin = '/onboarding/login';
  static const about = '/about';
  static const settingsOverview = '/settings';
  static const settingsAppearance = '/settings/appearance';
  static const settingsPlayer = '/settings/player';
  static const settingsSponsorblock = '/settings/sponsorblock';
  static const channelpageScreen = '/channel';
  static const playlistpageScreen = '/playlist';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      case home:
        return MaterialPageRoute(builder: (_) => const HomeContainer());

      case onboarding:
        return MaterialPageRoute(builder: (_) => OnBoardingPrivacyPolicyScreen());

      case onboardingLogin:
        return MaterialPageRoute(builder: (_) => OnBoardingLoginScreen());
        
      case about:
        return MaterialPageRoute(builder: (_) => AboutScreen());
      
      case settingsOverview:
        return MaterialPageRoute(builder: (_) => SettingsScreen());

      case settingsAppearance:
        return MaterialPageRoute(builder: (_) => AppearanceSettingsScreen());

      case settingsPlayer:
        return MaterialPageRoute(builder: (_) => PlayerSettingsScreen());

      case settingsSponsorblock:
        return MaterialPageRoute(builder: (_) => SponsorblockSettingsScreen());

      case channelpageScreen:
        final channelId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ChannelpageScreen(
          channelId: channelId
        )
      );

      case playlistpageScreen:
        final playlistId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => PlaylistpageScreen(
          playlistId: playlistId
        )
      );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
