import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

String formatTimeAgo(BuildContext context, String isoDateStr) {
  final localizations = AppLocalizations.of(context)!;
  DateTime past = DateTime.parse(isoDateStr).toUtc();
  DateTime now = DateTime.now().toUtc();
  Duration diff = now.difference(past);

  if (diff.inSeconds < 60) {
    final count = diff.inSeconds;
    return count == 1
        ? localizations.secondAgo(count)
        : localizations.secondsAgo(count);
  } else if (diff.inMinutes < 60) {
    final count = diff.inMinutes;
    return count == 1
        ? localizations.minuteAgo(count)
        : localizations.minutesAgo(count);
  } else if (diff.inHours < 24) {
    final count = diff.inHours;
    return count == 1
        ? localizations.hourAgo(count)
        : localizations.hoursAgo(count);
  } else if (diff.inDays < 365) {
    final count = diff.inDays;
    return count == 1
        ? localizations.dayAgo(count)
        : localizations.daysAgo(count);
  } else {
    final count = (diff.inDays / 365).floor();
    return count == 1
        ? localizations.yearAgo(count)
        : localizations.yearsAgo(count);
  }
}
