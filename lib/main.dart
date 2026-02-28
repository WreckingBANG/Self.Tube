import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/global_snackbar.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/common/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.load();
  VideoPlayerService.init();
  await DeviceService.init();
  await UserSession.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ColorScheme _resolveColorScheme({
    required bool isDark,
    required ColorScheme? dynamicScheme,
  }) {
    if (SettingsService.materialYouColors == false) {
      return ColorScheme.fromSeed(
        seedColor: fallbackSeedColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      );
    }
    return dynamicScheme ??
    ColorScheme.fromSeed(
      seedColor: fallbackSeedColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          scaffoldMessengerKey: GlobalSnackbar.key,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('de'),
            Locale('pl'),
          ],
          title: 'Self.Tube',
          theme: lightThemeFrom(
            _resolveColorScheme(isDark: false, dynamicScheme: lightDynamic),
          ),
          darkTheme: darkThemeFrom(
            _resolveColorScheme(isDark: true, dynamicScheme: darkDynamic),
          ),
          initialRoute: SettingsService.doneSetup == true
              ? AppRouter.home
              : AppRouter.onboarding,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
