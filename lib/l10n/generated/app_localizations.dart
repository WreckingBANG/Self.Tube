import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Self.Tube'**
  String get appTitle;

  /// No description provided for @barHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get barHome;

  /// No description provided for @barChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get barChannels;

  /// No description provided for @barPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get barPlaylists;

  /// No description provided for @barActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get barActions;

  /// No description provided for @tooltipSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tooltipSearch;

  /// No description provided for @tooltipSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tooltipSettings;

  /// No description provided for @homeLatestVideos.
  ///
  /// In en, this message translates to:
  /// **'Latest Videos'**
  String get homeLatestVideos;

  /// No description provided for @homeContinueWatching.
  ///
  /// In en, this message translates to:
  /// **'Continue Watching'**
  String get homeContinueWatching;

  /// No description provided for @settingsSheetApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsSheetApp;

  /// No description provided for @settingsSheetSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSheetSettings;

  /// No description provided for @settingsSheetDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get settingsSheetDownloads;

  /// No description provided for @settingsSheetLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsSheetLogout;

  /// No description provided for @settingsSheetAbout.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get settingsSheetAbout;

  /// No description provided for @settingsSheetServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get settingsSheetServer;

  /// No description provided for @settingsSheetLibraryStats.
  ///
  /// In en, this message translates to:
  /// **'Library Statistics'**
  String get settingsSheetLibraryStats;

  /// No description provided for @settingsShowCommentPics.
  ///
  /// In en, this message translates to:
  /// **'Show Commentator Pictures'**
  String get settingsShowCommentPics;

  /// No description provided for @settingsShowCommentPicsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This will make a connection to Google as the Images are not stored by TubeArchivist'**
  String get settingsShowCommentPicsDisclaimer;

  /// No description provided for @settingsSheetComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get settingsSheetComingSoon;

  /// No description provided for @errorNoDataFound.
  ///
  /// In en, this message translates to:
  /// **'Error: No data found'**
  String get errorNoDataFound;

  /// No description provided for @errorFailedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Error: Failed to load'**
  String get errorFailedToLoadData;

  /// No description provided for @numberformatThousand.
  ///
  /// In en, this message translates to:
  /// **'K'**
  String get numberformatThousand;

  /// No description provided for @numberformatMillion.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get numberformatMillion;

  /// No description provided for @numberformatBillion.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get numberformatBillion;

  /// No description provided for @numberformatTrillion.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get numberformatTrillion;

  /// No description provided for @sheetLocalActions.
  ///
  /// In en, this message translates to:
  /// **'Local Actions'**
  String get sheetLocalActions;

  /// No description provided for @sheetMarkWatched.
  ///
  /// In en, this message translates to:
  /// **'Mark as watched'**
  String get sheetMarkWatched;

  /// No description provided for @sheetMarkUnwatched.
  ///
  /// In en, this message translates to:
  /// **'Mark as unwatched'**
  String get sheetMarkUnwatched;

  /// No description provided for @sheetOpenChannel.
  ///
  /// In en, this message translates to:
  /// **'Open channel'**
  String get sheetOpenChannel;

  /// No description provided for @sheetShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sheetShare;

  /// No description provided for @sheetDownloadLocal.
  ///
  /// In en, this message translates to:
  /// **'Download to device'**
  String get sheetDownloadLocal;

  /// No description provided for @sheetServerActions.
  ///
  /// In en, this message translates to:
  /// **'Server actions'**
  String get sheetServerActions;

  /// No description provided for @sheetRedownloadServer.
  ///
  /// In en, this message translates to:
  /// **'Redownload to server'**
  String get sheetRedownloadServer;

  /// No description provided for @sheetDeleteVideoServer.
  ///
  /// In en, this message translates to:
  /// **'Delete video from server'**
  String get sheetDeleteVideoServer;

  /// No description provided for @sheetComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get sheetComingSoon;

  /// No description provided for @listShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get listShowMore;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsInstanceUrl.
  ///
  /// In en, this message translates to:
  /// **'Instance URL'**
  String get settingsInstanceUrl;

  /// No description provided for @settingsApiToken.
  ///
  /// In en, this message translates to:
  /// **'API Token'**
  String get settingsApiToken;

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchLabel;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @playlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlistTitle;

  /// No description provided for @playlistVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get playlistVideos;

  /// No description provided for @channelSubscribers.
  ///
  /// In en, this message translates to:
  /// **'Subscribers: '**
  String get channelSubscribers;

  /// No description provided for @playerTitle.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get playerTitle;

  /// No description provided for @playerViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get playerViews;

  /// No description provided for @playerSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get playerSubscribe;

  /// No description provided for @playerUnsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get playerUnsubscribe;

  /// No description provided for @playerDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get playerDescription;

  /// No description provided for @playerComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get playerComments;

  /// No description provided for @playerSimilar.
  ///
  /// In en, this message translates to:
  /// **'Similar videos'**
  String get playerSimilar;

  /// No description provided for @actionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsTitle;

  /// No description provided for @channelTitle.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get channelTitle;

  /// No description provided for @channelVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get channelVideos;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
