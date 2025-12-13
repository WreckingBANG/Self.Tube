import 'package:Self.Tube/screens/channelpage_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/number_formatter.dart';
import '../../services/settings_service.dart';
import '../../l10n/generated/app_localizations.dart';

class ChannelListTile extends StatelessWidget {
  final dynamic channel;

  const ChannelListTile({super.key, required this.channel});

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;

  @override
  Widget build(BuildContext context) {
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
                  child: CachedNetworkImage(
                    imageUrl: "$baseUrl/${channel.profilePic}",
                    httpHeaders: {
                      'Authorization': 'token $apiToken',
                    },
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChannelpageScreen(channelId: channel.channelId)),
          );
        },
      ),
    );
  }
}

