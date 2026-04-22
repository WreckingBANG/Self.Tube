import 'package:flutter/material.dart';

const Color fallbackSeedColor = Color(0xff1e766a);

ThemeData lightThemeFrom(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Figtree',
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Figtree-Medium'
    ),
    cardTheme: CardThemeData(
      color: Color.alphaBlend(
        colorScheme.primary.withValues(alpha: 0.1),
        colorScheme.surface
      ),
      elevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.surface,
      contentTextStyle: TextStyle(color: colorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

ThemeData darkThemeFrom(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Figtree',
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Figtree-Medium'),
    cardTheme: CardThemeData(
      color: Color.alphaBlend(
        colorScheme.primary.withValues(alpha: 0.08),
        colorScheme.surface
      ),
      elevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.surface,
      contentTextStyle: TextStyle(color: colorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

ThemeData getDefaultLightTheme() => lightThemeFrom(
  ColorScheme.fromSeed(seedColor: fallbackSeedColor, brightness: Brightness.light),
);

ThemeData getDefaultDarkTheme() => darkThemeFrom(
  ColorScheme.fromSeed(seedColor: fallbackSeedColor, brightness: Brightness.dark),
);
