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

  /// No description provided for @settingsAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSettings;

  /// No description provided for @settingsAccountSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Instance, Api-Key, ...'**
  String get settingsAccountSettingsDesc;

  /// No description provided for @settingsAppearanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSettings;

  /// No description provided for @settingsAppearanceSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get settingsAppearanceSettingsDesc;

  /// No description provided for @settingsVideoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Video Player'**
  String get settingsVideoPlayer;

  /// No description provided for @settingsVideoPlayerDesc.
  ///
  /// In en, this message translates to:
  /// **'Gesture Settings, ...'**
  String get settingsVideoPlayerDesc;

  /// No description provided for @settingsSponsorBlockSettings.
  ///
  /// In en, this message translates to:
  /// **'SponsorBlock'**
  String get settingsSponsorBlockSettings;

  /// No description provided for @settingsSponsorBlockSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Settings for SponsorBlock'**
  String get settingsSponsorBlockSettingsDesc;

  /// No description provided for @settingsM3Colors.
  ///
  /// In en, this message translates to:
  /// **'Enable Dynamic Colors'**
  String get settingsM3Colors;

  /// No description provided for @settingsVPGesturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Gestures'**
  String get settingsVPGesturesTitle;

  /// No description provided for @settingsVPGesturesSwipeCtrl.
  ///
  /// In en, this message translates to:
  /// **'Swipe controls'**
  String get settingsVPGesturesSwipeCtrl;

  /// No description provided for @settingsVPGesturesSwipeCtrlDesc.
  ///
  /// In en, this message translates to:
  /// **'Swipe the left and right parts of the player to adjust volume and brightness'**
  String get settingsVPGesturesSwipeCtrlDesc;

  /// No description provided for @settingsVPGesturesFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen gesture'**
  String get settingsVPGesturesFullscreen;

  /// No description provided for @settingsVPGesturesFullscreenDesc.
  ///
  /// In en, this message translates to:
  /// **'Swipe up/down in the center to enter/exit fullscreen'**
  String get settingsVPGesturesFullscreenDesc;

  /// No description provided for @settingsVPGesturesPinch.
  ///
  /// In en, this message translates to:
  /// **'Pinch to zoom'**
  String get settingsVPGesturesPinch;

  /// No description provided for @settingsVPGesturesPinchDesc.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get settingsVPGesturesPinchDesc;

  /// No description provided for @settingsVPGesturesDoubleTap.
  ///
  /// In en, this message translates to:
  /// **'Double Tap'**
  String get settingsVPGesturesDoubleTap;

  /// No description provided for @settingsVPGesturesDoubleTapDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap twice quickly on the right and left side of the player to skip/rewind and the center to play/pause'**
  String get settingsVPGesturesDoubleTapDesc;

  /// No description provided for @settingsVPUseMediaKit.
  ///
  /// In en, this message translates to:
  /// **'Use media_kit instead of video_player'**
  String get settingsVPUseMediaKit;

  /// No description provided for @settingsVPUseMediaKitDesc.
  ///
  /// In en, this message translates to:
  /// **'Dont change this unless you know what you are doing'**
  String get settingsVPUseMediaKitDesc;

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

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Type to search'**
  String get searchTooltip;

  /// No description provided for @searchVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get searchVideos;

  /// No description provided for @searchChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get searchChannels;

  /// No description provided for @searchPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get searchPlaylists;

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

  /// No description provided for @onboardingLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get onboardingLogin;

  /// No description provided for @onboardingUrlExample.
  ///
  /// In en, this message translates to:
  /// **'https://tubearchivist.example.com'**
  String get onboardingUrlExample;

  /// No description provided for @onboardingUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get onboardingUsername;

  /// No description provided for @onboardingPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get onboardingPassword;

  /// No description provided for @onboardingToken.
  ///
  /// In en, this message translates to:
  /// **'Api-Token'**
  String get onboardingToken;

  /// No description provided for @onboardingInstanceUrl.
  ///
  /// In en, this message translates to:
  /// **'Instance URL'**
  String get onboardingInstanceUrl;

  /// No description provided for @onboardingTokenExample.
  ///
  /// In en, this message translates to:
  /// **'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'**
  String get onboardingTokenExample;

  /// No description provided for @onboardingLoginFailure.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Please check your token and URL.'**
  String get onboardingLoginFailure;

  /// No description provided for @onboardingWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Self.Tube'**
  String get onboardingWelcomeText;

  /// No description provided for @onboardingMarketing1.
  ///
  /// In en, this message translates to:
  /// **'Browse and manage your self-hosted TubeArchivist Instance with ease.'**
  String get onboardingMarketing1;

  /// No description provided for @onboardingMarketing2.
  ///
  /// In en, this message translates to:
  /// **'Access your entire TubeArchivist Instance'**
  String get onboardingMarketing2;

  /// No description provided for @onboardingMarketing3.
  ///
  /// In en, this message translates to:
  /// **'Manage your archive'**
  String get onboardingMarketing3;

  /// No description provided for @onboardingMarketing4.
  ///
  /// In en, this message translates to:
  /// **'View your Videos in a native like experience'**
  String get onboardingMarketing4;

  /// No description provided for @onboardingPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get onboardingPrivacyPolicy;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Agree & Continue'**
  String get onboardingContinue;

  /// No description provided for @sponsorblockEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Sponsorblock'**
  String get sponsorblockEnable;

  /// No description provided for @sponsorblockSponsor.
  ///
  /// In en, this message translates to:
  /// **'Skip Sponsor'**
  String get sponsorblockSponsor;

  /// No description provided for @sponsorblockPromo.
  ///
  /// In en, this message translates to:
  /// **'Skip Self-Promotion'**
  String get sponsorblockPromo;

  /// No description provided for @sponsorblockInteraction.
  ///
  /// In en, this message translates to:
  /// **'Skip Interaction-Reminder'**
  String get sponsorblockInteraction;

  /// No description provided for @sponsorblockIntro.
  ///
  /// In en, this message translates to:
  /// **'Skip Intro'**
  String get sponsorblockIntro;

  /// No description provided for @sponsorblockOutro.
  ///
  /// In en, this message translates to:
  /// **'Skip Outro'**
  String get sponsorblockOutro;

  /// No description provided for @sponsorblockPreview.
  ///
  /// In en, this message translates to:
  /// **'Skip Preview'**
  String get sponsorblockPreview;

  /// No description provided for @sponsorblockHook.
  ///
  /// In en, this message translates to:
  /// **'Skip Hook'**
  String get sponsorblockHook;

  /// No description provided for @sponsorblockFiller.
  ///
  /// In en, this message translates to:
  /// **'Skip Filler'**
  String get sponsorblockFiller;

  /// No description provided for @expandableTextMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get expandableTextMore;

  /// No description provided for @expandableTextLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get expandableTextLess;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get aboutLicense;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developed by WreckingBANG'**
  String get aboutDeveloper;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get aboutSourceCode;

  /// No description provided for @aboutReleases.
  ///
  /// In en, this message translates to:
  /// **'Releases'**
  String get aboutReleases;

  /// No description provided for @aboutScrollDependencies.
  ///
  /// In en, this message translates to:
  /// **'Scroll down to see dependencies'**
  String get aboutScrollDependencies;

  /// No description provided for @aboutDependencies.
  ///
  /// In en, this message translates to:
  /// **'Dependencies'**
  String get aboutDependencies;

  /// No description provided for @videoListViews.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get videoListViews;

  /// No description provided for @secondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} seconds ago'**
  String secondsAgo(Object count);

  /// No description provided for @secondAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} second ago'**
  String secondAgo(Object count);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(Object count);

  /// No description provided for @minuteAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minute ago'**
  String minuteAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(Object count);

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hour ago'**
  String hourAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} day ago'**
  String dayAgo(Object count);

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(Object count);

  /// No description provided for @yearAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} year ago'**
  String yearAgo(Object count);

  /// No description provided for @playerBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get playerBrightness;

  /// No description provided for @playerForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get playerForward;

  /// No description provided for @playerRewind.
  ///
  /// In en, this message translates to:
  /// **'Rewind'**
  String get playerRewind;

  /// No description provided for @playerSeconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get playerSeconds;

  /// No description provided for @playerMinimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get playerMinimize;

  /// No description provided for @playerMaximize.
  ///
  /// In en, this message translates to:
  /// **'Maximize'**
  String get playerMaximize;

  /// No description provided for @playerPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get playerPaused;

  /// No description provided for @playerPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playerPlay;

  /// No description provided for @playerVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get playerVolume;

  /// No description provided for @playerSBSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped {category} from {start} to {end}'**
  String playerSBSkipped(Object category, Object end, Object start);

  /// No description provided for @playerRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get playerRepeat;

  /// No description provided for @playerBorderMode.
  ///
  /// In en, this message translates to:
  /// **'Border Mode'**
  String get playerBorderMode;

  /// No description provided for @playerBorderModeContain.
  ///
  /// In en, this message translates to:
  /// **'Contain (Black Bars)'**
  String get playerBorderModeContain;

  /// No description provided for @playerBorderModeCover.
  ///
  /// In en, this message translates to:
  /// **'Cover (Crop)'**
  String get playerBorderModeCover;

  /// No description provided for @playerBorderModeStretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch'**
  String get playerBorderModeStretch;

  /// No description provided for @playerPlaybackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playerPlaybackSpeed;

  /// No description provided for @chipsOrderAsc.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get chipsOrderAsc;

  /// No description provided for @chipsOrderDes.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get chipsOrderDes;

  /// No description provided for @chipsSortPub.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get chipsSortPub;

  /// No description provided for @chipsSortDow.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get chipsSortDow;

  /// No description provided for @chipsSortVie.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get chipsSortVie;

  /// No description provided for @chipsSortLik.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get chipsSortLik;

  /// No description provided for @chipsSortDur.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get chipsSortDur;

  /// No description provided for @chipsSortSiz.
  ///
  /// In en, this message translates to:
  /// **'Media Size'**
  String get chipsSortSiz;

  /// No description provided for @chipsSortWid.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get chipsSortWid;

  /// No description provided for @chipsSortHei.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get chipsSortHei;

  /// No description provided for @chipsTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get chipsTypeAll;

  /// No description provided for @chipsTypeVid.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get chipsTypeVid;

  /// No description provided for @chipsTypeStr.
  ///
  /// In en, this message translates to:
  /// **'Streams'**
  String get chipsTypeStr;

  /// No description provided for @chipsTypeSho.
  ///
  /// In en, this message translates to:
  /// **'Shorts'**
  String get chipsTypeSho;

  /// No description provided for @chipsWatchedAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get chipsWatchedAll;

  /// No description provided for @chipsWatchedWat.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get chipsWatchedWat;

  /// No description provided for @chipsWatchedUnw.
  ///
  /// In en, this message translates to:
  /// **'Unwatched'**
  String get chipsWatchedUnw;

  /// No description provided for @chipsWatchedCon.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get chipsWatchedCon;
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
