import 'package:flutter/material.dart';
import 'package:Self.Tube/common/theme/theme.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';

class ThemeHelper {

  static ColorScheme resolveColorScheme({
    required bool isDark,
    required ColorScheme? dynamicScheme,
  }) {
    if (SettingsService.materialYouColors == false || dynamicScheme == null) {
      return ColorScheme.fromSeed(
        seedColor: fallbackSeedColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        dynamicSchemeVariant: DynamicSchemeVariant.vibrant
      );
    }
    return ColorScheme.fromSeed(
      seedColor: dynamicScheme.primary,
      brightness: isDark ? Brightness.dark : Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant
    );
  }

}
