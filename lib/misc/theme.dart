import 'package:flutter/material.dart';

const Color fallbackSeedColor = Color(0xff1e766a);

ThemeData lightThemeFrom(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.75),
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onPrimaryContainer,
      textColor: colorScheme.onPrimaryContainer,
    ),
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
    scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
    cardTheme: CardThemeData(
      color: colorScheme.primary.withOpacity(0.08),
      surfaceTintColor: null,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onPrimaryContainer,
      textColor: colorScheme.onPrimaryContainer,
    ),
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
