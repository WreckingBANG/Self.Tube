import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/common/utils/number_formatter.dart';
import 'package:Self.Tube/features/channel/ui/sheets/channel_list_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChannelListTile extends ConsumerWidget {
  final dynamic channel;
  final void Function()? onDelete;
  
  const ChannelListTile({
    super.key, 
    required this.channel,
  required this.onDelete
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),  
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CustomNetwokImage(imageLink: channel.profilePic)
                )   
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.channelName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${localizations.channelSubscribers} ${formatNumberCompact(channel.subscribers, context)}",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              )  
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context, 
            AppRouter.channelpageScreen,
            arguments: channel.channelId
          );
        },
        onLongPress: () {
          showChannelListBottomSheet(
            context: context, 
            channel: channel,
            ref: ref,
            onDelete: onDelete
          );
        },
      ),
    );
  }
}

