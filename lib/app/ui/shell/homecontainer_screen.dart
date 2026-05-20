import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/app/ui/home/home_screen.dart';
import 'package:Self.Tube/app/ui/shell/app_settings_bottomsheet.dart';
import 'package:Self.Tube/common/ui/widgets/sections/error_section.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session_provider.dart';
import 'package:Self.Tube/features/player/ui/tiles/mini_player_tile.dart';
import 'package:Self.Tube/features/tasks/ui/screens/actions_screen.dart';
import 'package:Self.Tube/features/channel/ui/screens/channels_screen.dart';
import 'package:Self.Tube/features/playlist/ui/screens/playlists_screen.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContainerScreen extends ConsumerWidget {
  const HomeContainerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userSessionProvider);

    return user.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("$error")),
      data: (isSuccess) {
        
        if (isSuccess) {
          return HomeContainer();
        } else {
          return Scaffold(
            body: Center(
              child: ErrorSection(
                provider: userSessionProvider,
                ref: ref
              )
            ),
          );
        }
      } 
    );
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
        titleSpacing: 0,
        leadingWidth: 60,
        leading: Image.asset(
          'assets/appicon.png',
          width: 60,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: localizations.tooltipSearch,
            onPressed: () {
              Navigator.pushNamed(
                context, 
                AppRouter.search,
              );
            },
          ),
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
          if (UserSession.isPrivileged)
            NavigationDestination(
              selectedIcon: Icon(Icons.add),
              icon: Icon(Icons.add),
              label: localizations.barActions,
            ),
        ],
      ),
      body: MiniPlayerTile(
        child: <Widget>[
          HomeScreen(), 
          
          ChannelsScreen(),

          PlaylistsScreen(),

          ActionsScreen(),

        ][currentPageIndex],
      )
    );
  }
}
