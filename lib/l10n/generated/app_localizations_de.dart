// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Self.Tube';

  @override
  String get barHome => 'Startseite';

  @override
  String get barChannels => 'Kanäle';

  @override
  String get barPlaylists => 'Wiedergabelisten';

  @override
  String get barActions => 'Aktionen';

  @override
  String get tooltipSearch => 'Suche';

  @override
  String get tooltipSettings => 'Einstellungen';

  @override
  String get homeLatestVideos => 'Letzte Videos';

  @override
  String get homeContinueWatching => 'Weiterschauen';

  @override
  String get errorNoDataFound => 'Fehler: Keine Daten gefunden';

  @override
  String get numberformatThousand => 'Tsd.';

  @override
  String get numberformatMillion => 'Mio.';

  @override
  String get numberformatBillion => 'Mrd.';

  @override
  String get numberformatTrillion => 'Bio.';
}
