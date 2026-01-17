import 'package:Self.Tube/app/ui/home/home_screen.dart';
import 'package:Self.Tube/app/ui/shell/app_settings_bottomsheet.dart';
import 'package:Self.Tube/features/admin/ui/screens/actions_screen.dart';
import 'package:Self.Tube/features/channel/ui/screens/channels_screen.dart';
import 'package:Self.Tube/features/playlist/ui/screens/playlists_screen.dart';
import 'package:Self.Tube/features/search/ui/sections/search_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

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