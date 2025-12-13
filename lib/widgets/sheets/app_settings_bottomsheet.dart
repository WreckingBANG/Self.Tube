import 'package:flutter/material.dart';
import './bottomsheet_template.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/screens/settings/overview_settings_screen.dart';
import 'package:Self.Tube/services/settings_service.dart';
import 'package:Self.Tube/main.dart';
import 'package:Self.Tube/screens/about_screen.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

Future<void> showAppSettingsBottomSheet({
  required BuildContext context,

  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  return showBottomSheetTemplate(
    context: context, 
    children: [
      ListSectionContainer(
        title: localizations.settingsSheetApp,
        children: [
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
        ],
      ),
      ListSectionContainer(
        title: localizations.settingsSheetServer,
        children: [
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
        ],
      )
    ]
  );
}
