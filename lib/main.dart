import 'package:Self.Tube/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'l10n/generated/app_localizations.dart';
import 'screens/bottomnavbar_screen.dart';
import 'screens/onboarding/privacypolicy_screen.dart';
import 'package:media_kit/media_kit.dart'; 
import 'misc/theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.load();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          localizationsDelegates: [
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
          theme: lightThemeFrom(lightDynamic ?? ColorScheme.fromSeed(seedColor: fallbackSeedColor, brightness: Brightness.light)),
          darkTheme: darkThemeFrom(darkDynamic ?? ColorScheme.fromSeed(seedColor: fallbackSeedColor, brightness: Brightness.dark)),
          home: SettingsService.doneSetup == true
              ? const BottNavBar()
              : OnBoardingPrivacyPolicyScreen(),
        );
      },
    );
  }
}
