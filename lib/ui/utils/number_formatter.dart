import 'package:flutter/widgets.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

String formatNumberCompact(num number, BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  if (number >= 1e12) {
    return '${(number / 1e12).toStringAsFixed(1)} ${localizations.numberformatTrillion}';
  } else if (number >= 1e9) {
    return '${(number / 1e9).toStringAsFixed(1)} ${localizations.numberformatBillion}';
  } else if (number >= 1e6) {
    return '${(number / 1e6).toStringAsFixed(1)} ${localizations.numberformatMillion}';
  } else if (number >= 1e3) {
    return '${(number / 1e3).toStringAsFixed(1)} ${localizations.numberformatThousand}';
  } else {
    return number.toString();
  }
}
