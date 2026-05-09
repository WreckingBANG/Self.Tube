import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter/material.dart';

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    maxHistoryItems: 1000,
  ),
);

TalkerScreenTheme getTalkerTheme(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return TalkerScreenTheme(
    backgroundColor: colorScheme.surface,
    textColor: colorScheme.onSurface,
  );
}
