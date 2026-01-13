import 'package:Self.Tube/core/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/settings/ui/screens/appearance_settings_screen.dart';
import 'package:Self.Tube/features/settings/ui/screens/player_settings_screen.dart';
import 'package:Self.Tube/features/settings/ui/screens/sponsorblock_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return 
    Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: ListSectionContainer(
        children: [
          ListTile(
            title: Text(localizations.settingsAppearanceSettings),
            subtitle: Text(localizations.settingsAppearanceSettingsDesc),
            leading: Icon(Icons.design_services_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppearanceSettingsScreen()),
                );
            },
          ),
          ListTile(
            title: Text(localizations.settingsVideoPlayer),
            subtitle: Text(localizations.settingsVideoPlayerDesc),
            leading: Icon(Icons.play_arrow_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerSettingsScreen()),
                );
            },
          ),
          ListTile(
            title: Text(localizations.settingsSponsorBlockSettings),
            subtitle: Text(localizations.settingsSponsorBlockSettings),
            leading: Icon(Icons.money_off),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SponsorblockSettingsScreen()),
                );
            },
          ),
        ]
      ),
    );
  }
}
