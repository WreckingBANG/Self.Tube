// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Self.Tube';

  @override
  String get barHome => 'Home';

  @override
  String get barChannels => 'Channels';

  @override
  String get barPlaylists => 'Playlists';

  @override
  String get barActions => 'Actions';

  @override
  String get tooltipSearch => 'Search';

  @override
  String get tooltipSettings => 'Settings';

  @override
  String get homeLatestVideos => 'Latest Videos';

  @override
  String get homeContinueWatching => 'Continue Watching';

  @override
  String get errorNoDataFound => 'Error: No Data found';

  @override
  String get numberformatThousand => 'K';

  @override
  String get numberformatMillion => 'M';

  @override
  String get numberformatBillion => 'B';

  @override
  String get numberformatTrillion => 'T';
}
