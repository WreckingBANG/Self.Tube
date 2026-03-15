import 'package:Self.Tube/features/channel/domain/channellist_provider.dart';
import 'package:Self.Tube/features/channel/ui/dialogs/add_channel_dialog.dart';
import 'package:Self.Tube/features/channel/ui/sections/channel_list_section.dart';
import 'package:Self.Tube/features/onboarding/domain/user_session.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelsScreen extends ConsumerWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
  
    final query = "?filter=subscribed";
    final provider = ref.read(channelListProvider(query).notifier);

    return Scaffold(
      floatingActionButton: UserSession.isPrivileged 
        ? FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) => AddChannelDialog(query: query)
              );
            },
            tooltip: localizations.channelAdd,
            child: Icon(Icons.add),
          )
        : null,
      body: RefreshIndicator(
        onRefresh: () async {
          provider.refresh();
        },
        child: ListView(
          children: [
            ChannelListSection(query: query)
          ],
        )
      ),
    );
  }
}
