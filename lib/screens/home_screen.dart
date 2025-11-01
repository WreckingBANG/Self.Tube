import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import '../widgets/video_list_section.dart';
import '../screens/search_screen.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/settings_service.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Key _contentKey = UniqueKey();

  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _contentKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: localizations.tooltipSearch,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.manage_accounts_outlined),
            tooltip: localizations.tooltipSettings,
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 470,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: 
                      Column(
                        children: [
                          Card(
                            color: Theme.of(context).colorScheme.surfaceContainerLowest,
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(localizations.settingsSheetApp),
                                ListTile(
                                  leading: Icon(Icons.settings),
                                  title: Text(localizations.settingsSheetSettings),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.download),
                                  title: Text(localizations.settingsSheetDownloads),
                                  subtitle: Text(localizations.settingsSheetComingSoon),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text(localizations.settingsSheetLogout),
                                  onTap: () async {
                                    await SettingsService.setDoneSetup(false);
                                    await SettingsService.setInstanceUrl("");
                                    await SettingsService.setApiToken("");
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyApp()),
                                      (route) => false,
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.info),
                                  title: Text(localizations.settingsSheetAbout),
                                  subtitle: Text(localizations.settingsSheetComingSoon),
                                  onTap: () {},
                                ),
                              ]
                            ),
                          ),
                          Card(
                            color: Theme.of(context).colorScheme.surfaceContainerLowest,
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(localizations.settingsSheetServer),
                                ListTile(
                                  leading: Icon(Icons.settings),
                                  title: Text(localizations.settingsSheetSettings),
                                  subtitle: Text(localizations.settingsSheetComingSoon),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: Icon(Icons.bar_chart_rounded),
                                  title: Text(localizations.settingsSheetLibraryStats),
                                  subtitle: Text(localizations.settingsSheetComingSoon),
                                  onTap: () {},
                                ),
                              ]
                            ),
                          ),
                        ],
                      )
                    )
                  );
                },
              );
            }
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            key: _contentKey,
            children: [
              VideoListSection(
                title: localizations.homeContinueWatching,
                query: "?order=asc&sort=published&watch=continue",
              ),
              const Divider(thickness: 2),
              VideoListSection(
                title: localizations.homeLatestVideos,
                query: "?order=desc&sort=published&type=videos",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
