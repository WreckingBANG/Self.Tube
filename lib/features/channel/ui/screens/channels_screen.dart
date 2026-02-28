import 'package:Self.Tube/common/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/features/channel/ui/dialogs/add_channel_dialog.dart';
import 'package:Self.Tube/features/channel/ui/sections/channel_list_section.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      floatingActionButton: UserSession.isPrivileged 
        ? FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) => AddChannelDialog()
              );
            },
            tooltip: localizations.channelAdd,
            child: Icon(Icons.add),
          )
        : null,
      body: RefreshContainer(
        child: ListView(
          children: [
            ChannelListSection(query: "?filter=subscribed")
          ],
        )
      ),
    );
  }
}
