import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/core/data/services/device/device_service.dart';
import 'package:Self.Tube/core/data/services/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:media_kit/media_kit.dart'; 
import 'package:Self.Tube/core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.load();
  await DeviceService.init();
  MediaKit.ensureInitialized();
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('de'),
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
