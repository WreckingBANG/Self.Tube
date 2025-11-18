import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/playlists_screen.dart';
import '../screens/actions_screen.dart';
import '../l10n/generated/app_localizations.dart';
import '../screens/search_screen.dart';
import '../screens/settings/overview_screen.dart';
import '../screens/about_screen.dart';
import '../services/settings_service.dart';
import '../main.dart';

class HomeContainerScreen extends StatelessWidget {
  const HomeContainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeContainer());
  }
}

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int currentPageIndex = 0;

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
                showDragHandle: true,
                isScrollControlled: true,
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
                                    Navigator.pop(context);
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
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text(localizations.settingsSheetLogout),
                                  onTap: () async {
                                    Navigator.pop(context);
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
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AboutScreen()),
                                    );
                                  },
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
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.bar_chart_rounded),
                                  title: Text(localizations.settingsSheetLibraryStats),
                                  subtitle: Text(localizations.settingsSheetComingSoon),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: localizations.barHome,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2),
            icon: Icon(Icons.person_2_outlined),
            label: localizations.barChannels,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.playlist_add),
            icon: Icon(Icons.playlist_add),
            label: localizations.barPlaylists,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add),
            icon: Icon(Icons.add),
            label: localizations.barActions,
          ),
        ],
      ),
      body: <Widget>[

        HomeScreen(),

        ChannelsScreen(),

        PlaylistsScreen(),

        ActionsScreen(),

        ][currentPageIndex],
    );
  }
}