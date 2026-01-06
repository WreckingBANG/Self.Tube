import 'package:flutter/material.dart';
import 'bottomsheet_template.dart';
import 'package:Self.Tube/main.dart';
import 'package:Self.Tube/domain/controllers/auth_controller.dart';
import 'package:Self.Tube/ui/screens/about_screen.dart';
import 'package:Self.Tube/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/ui/screens/settings/overview_settings_screen.dart';
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
              _handleLogout(context);
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

Future<void> _handleLogout(BuildContext context) async {
  Navigator.pop(context);

  final controller = AuthController();
  final success = await controller.logout();

  if (success) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MyApp()),
      (route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logout failed")),
    );
  }
}

