import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showAppSettingsBottomSheet({
  required BuildContext context,

  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  return showBottomSheetTemplate(
    context: context, 
    children: [ 
      Consumer(
        builder: (context, ref, child) {
          return Column(
            children: [
              ListSectionContainer(
                title: localizations.settingsSheetApp,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
                    title: Text(UserSession.user!.userName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(SettingsService.instanceUrl ?? ""),
                        Row(
                          children: [
                            if (UserSession.user!.isStaff)
                              Chip(
                                padding: EdgeInsets.zero,
                                label: Row(
                                  children: [
                                    Icon(Icons.shield_outlined, size: 15),
                                    SizedBox(width: 2),
                                    Text(localizations.userStaff),  
                                  ]
                                )
                              ),
                            SizedBox(width: 5),
                            if (UserSession.user!.isSuperUser)
                              Chip(
                                padding: EdgeInsets.zero,
                                label: Row(
                                  children: [
                                    Icon(Icons.workspace_premium_outlined, size: 17),
                                    SizedBox(width: 2),
                                    Text(localizations.userSuperUser),
                                  ],
                                )

                              )
                          ],
                        )
                      ],
                    )
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(localizations.settingsSheetSettings),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        AppRouter.settingsOverview,
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
                      ConfirmationDialog(
                        context: context, 
                        onSure: () {
                          _handleLogout(context, ref);
                        }
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(localizations.settingsSheetAbout),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        AppRouter.about,
                      );
                    },
                  ),
                ],
              ),
              if (UserSession.isPrivileged)
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
            ],
          );
        }
      )
    ]
  );
}

Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
  Navigator.pop(context);

  try {
    ref.read(userSessionProvider.notifier).logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.onboarding,
      (route) => false,
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logout failed")),
    );
  } 
}

