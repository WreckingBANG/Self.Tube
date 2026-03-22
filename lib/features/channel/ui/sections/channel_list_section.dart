import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/channel/domain/channellist_provider.dart';
import 'package:Self.Tube/features/channel/ui/tiles/channel_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelListSection extends ConsumerWidget {
  final String title;
  final String query;
  final bool hideIfEmpty;

  const ChannelListSection({
    super.key,
    required this.query,
    this.title = "",
    this.hideIfEmpty = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final provider = ref.read(channelListProvider(query).notifier);
    final channels = ref.watch(channelListProvider(query));

    return channels.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
      data: (channels) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (channels!.isEmpty && !hideIfEmpty)
              Center(child: Text(localizations.errorNoDataFound))
            else
              ListSectionContainer(
                itemCount: channels!.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  return ChannelListTile(
                    channel: channel,
                    onDelete: () => provider.deleteChannel(channel.channelId),
                  );
                }
              ),
            if (provider.hasMore && channels.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: provider.fetchNext,
                    child: Text(localizations.listShowMore),
                  ),
                ),
              ),
          ],
        );
      }
    );
  }
}
