import 'package:Self.Tube/widgets/sections/search_section.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/playlists_screen.dart';
import '../screens/actions_screen.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/sheets/app_settings_bottomsheet.dart';

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
          SearchScreenWidget(),
          IconButton(
            icon: const Icon(Icons.manage_accounts_outlined),
            tooltip: localizations.tooltipSettings,
            onPressed: () {
              showAppSettingsBottomSheet(context: context);
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