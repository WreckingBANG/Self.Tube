import 'package:flutter/material.dart';

const Color fallbackSeedColor = Color(0xff1e766a);

ThemeData lightThemeFrom(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18),
    ),
  );
}

ThemeData darkThemeFrom(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18),
    ),
  );
}

ThemeData getDefaultLightTheme() => lightThemeFrom(
  ColorScheme.fromSeed(seedColor: fallbackSeedColor, brightness: Brightness.light),
);

ThemeData getDefaultDarkTheme() => darkThemeFrom(
  ColorScheme.fromSeed(seedColor: fallbackSeedColor, brightness: Brightness.dark),
);
