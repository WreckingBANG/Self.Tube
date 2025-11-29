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
  String get settingsSheetApp => 'App';

  @override
  String get settingsSheetSettings => 'Settings';

  @override
  String get settingsSheetDownloads => 'Downloads';

  @override
  String get settingsSheetLogout => 'Logout';

  @override
  String get settingsSheetAbout => 'About the App';

  @override
  String get settingsSheetServer => 'Server';

  @override
  String get settingsSheetLibraryStats => 'Library Statistics';

  @override
  String get settingsShowCommentPics => 'Show Commentator Pictures';

  @override
  String get settingsShowCommentPicsDisclaimer =>
      'This will make a connection to Google as the Images are not stored by TubeArchivist';

  @override
  String get settingsSheetComingSoon => 'Coming Soon';

  @override
  String get errorNoDataFound => 'Error: No data found';

  @override
  String get errorFailedToLoadData => 'Error: Failed to load';

  @override
  String get numberformatThousand => 'K';

  @override
  String get numberformatMillion => 'M';

  @override
  String get numberformatBillion => 'B';

  @override
  String get numberformatTrillion => 'T';

  @override
  String get sheetLocalActions => 'Local Actions';

  @override
  String get sheetMarkWatched => 'Mark as watched';

  @override
  String get sheetMarkUnwatched => 'Mark as unwatched';

  @override
  String get sheetOpenChannel => 'Open channel';

  @override
  String get sheetShare => 'Share';

  @override
  String get sheetDownloadLocal => 'Download to device';

  @override
  String get sheetServerActions => 'Server actions';

  @override
  String get sheetRedownloadServer => 'Redownload to server';

  @override
  String get sheetDeleteVideoServer => 'Delete video from server';

  @override
  String get sheetComingSoon => 'Coming soon';

  @override
  String get listShowMore => 'Show more';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccountSettings => 'Account';

  @override
  String get settingsAccountSettingsDesc => 'Instance, Api-Key, ...';

  @override
  String get settingsAppearanceSettings => 'Appearance';

  @override
  String get settingsAppearanceSettingsDesc => '...';

  @override
  String get settingsSponsorBlockSettings => 'SponsorBlock';

  @override
  String get settingsSponsorBlockSettingsDesc => 'Settings for SponsorBlock';

  @override
  String get settingsInstanceUrl => 'Instance URL';

  @override
  String get settingsApiToken => 'API Token';

  @override
  String get settingsSave => 'Save';

  @override
  String get searchLabel => 'Search...';

  @override
  String get searchTitle => 'Search';

  @override
  String get playlistTitle => 'Playlist';

  @override
  String get playlistVideos => 'Videos';

  @override
  String get channelSubscribers => 'Subscribers: ';

  @override
  String get playerTitle => 'Player';

  @override
  String get playerViews => 'Views';

  @override
  String get playerSubscribe => 'Subscribe';

  @override
  String get playerUnsubscribe => 'Unsubscribe';

  @override
  String get playerDescription => 'Description';

  @override
  String get playerComments => 'Comments';

  @override
  String get playerSimilar => 'Similar videos';

  @override
  String get actionsTitle => 'Actions';

  @override
  String get channelTitle => 'Channel';

  @override
  String get channelVideos => 'Videos';

  @override
  String get onboardingLogin => 'Login';

  @override
  String get onboardingUrlExample => 'https://tubearchivist.example.com';

  @override
  String get onboardingTokenExample =>
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

  @override
  String get onboardingLoginFailure =>
      'Connection failed. Please check your token and URL.';

  @override
  String get onboardingWelcomeText => 'Welcome to Self.Tube';

  @override
  String get onboardingMarketing1 =>
      'Browse and manage your self-hosted TubeArchivist Instance with ease.';

  @override
  String get onboardingMarketing2 =>
      'Access your entire TubeArchivist Instance';

  @override
  String get onboardingMarketing3 => 'Manage your archive';

  @override
  String get onboardingMarketing4 =>
      'View your Videos in a native like experience';

  @override
  String get onboardingPrivacyPolicy => 'Privacy Policy';

  @override
  String get onboardingContinue => 'Agree & Continue';

  @override
  String get sponsorblockEnable => 'Enable Sponsorblock';

  @override
  String get sponsorblockSponsor => 'Skip Sponsor';

  @override
  String get sponsorblockPromo => 'Skip Self-Promotion';

  @override
  String get sponsorblockInteraction => 'Skip Interaction-Reminder';

  @override
  String get sponsorblockIntro => 'Skip Intro';

  @override
  String get sponsorblockOutro => 'Skip Outro';

  @override
  String get sponsorblockPreview => 'Skip Preview';

  @override
  String get sponsorblockHook => 'Skip Hook';

  @override
  String get sponsorblockFiller => 'Skip Filler';

  @override
  String get expandableTextMore => 'Show more';

  @override
  String get expandableTextLess => 'Show less';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutLicense => 'License';

  @override
  String get aboutDeveloper => 'Developed by WreckingBANG';

  @override
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutSourceCode => 'Source Code';

  @override
  String get aboutReleases => 'Releases';

  @override
  String get aboutScrollDependencies => 'Scroll down to see dependencies';

  @override
  String get aboutDependencies => 'Dependencies';

  @override
  String get videoListViews => 'views';

  @override
  String secondsAgo(Object count) {
    return '$count seconds ago';
  }

  @override
  String secondAgo(Object count) {
    return '$count second ago';
  }

  @override
  String minutesAgo(Object count) {
    return '$count minutes ago';
  }

  @override
  String minuteAgo(Object count) {
    return '$count minute ago';
  }

  @override
  String hoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String hourAgo(Object count) {
    return '$count hour ago';
  }

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String dayAgo(Object count) {
    return '$count day ago';
  }

  @override
  String yearsAgo(Object count) {
    return '$count years ago';
  }

  @override
  String yearAgo(Object count) {
    return '$count year ago';
  }

  @override
  String get playerBrightness => 'Brightness';

  @override
  String get playerForward => 'Forward';

  @override
  String get playerRewind => 'Rewind';

  @override
  String get playerSeconds => 'seconds';

  @override
  String get playerMinimize => 'Minimize';

  @override
  String get playerMaximize => 'Maximize';

  @override
  String get playerPaused => 'Paused';

  @override
  String get playerPlay => 'Play';

  @override
  String get playerVolume => 'Volume';

  @override
  String playerSBSkipped(Object category, Object end, Object start) {
    return 'Skipped $category from $start to $end';
  }
}
