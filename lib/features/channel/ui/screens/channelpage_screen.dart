import 'package:Self.Tube/common/ui/widgets/containers/expandable_text.dart';
import 'package:Self.Tube/common/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/common/ui/widgets/dialogs/confirmation_dialog.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/features/channel/domain/channelpage_provider.dart';
import 'package:Self.Tube/features/player/ui/tiles/mini_player_tile.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_section.dart';
import 'package:Self.Tube/common/utils/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChannelpageScreen extends ConsumerWidget{
  final String channelId;

  const ChannelpageScreen({
    super.key,
    required this.channelId,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final provider = ref.read(channelPageProvider(channelId).notifier);
    final channel = ref.watch(channelPageProvider(channelId));

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.channelTitle),
      ),
      body: MiniPlayerTile(
        child: RefreshContainer(
          child: channel.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
            data: (channel) {
              return ListView(
                children: [
                  if (channel!.banner.isNotEmpty)
                    CustomNetwokImage(imageLink: channel.banner),
                  ListTile(
                    title: Text(channel.channelName),
                    subtitle: Text(formatNumberCompact(channel.subscribers, context)),
                    leading: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomNetwokImage(imageLink: channel.profilePic)
                      ),
                    ),
                    trailing: channel.subscribed
                      ? FilledButton(
                          onPressed: () {
                            ConfirmationDialog(
                              context: context, 
                              onSure: () {
                                provider.subscribe(false);
                              } 
                            );
                          },
                          child: Text(localizations.playerUnsubscribe),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            provider.subscribe(true);
                          },
                          child: Text(localizations.playerSubscribe),
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ExpandableText(channel.description),
                    ),
                  ),
                  VideoListSection(title: localizations.channelVideos, showSorting: true, hideChannel: true, query: "?channel=$channelId&order=desc&sort=published&type=videos")
                 ],
              );
            }
          ) 
        )
      )
    );
  }
}

