import 'package:flutter/material.dart';
import 'instance_screen.dart';
import 'appearance_screen.dart';
import 'sponsorblock_screen.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';

class SettingsScreen extends StatefulWidget {
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
            title: Text(localizations.settingsAccountSettings),
            subtitle: Text(localizations.settingsAccountSettingsDesc),
            leading: Icon(Icons.account_circle_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InstanceSettingsScreen()),
                );
            },
          ),
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
            title: Text(localizations.settingsSponsorBlockSettings),
            subtitle: Text(localizations.settingsSponsorBlockSettings),
            leading: Icon(Icons.money_off),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SponsorblockSettingsScreen()),
                );
            },
          )
        ]
      ),
    );
  }
}
