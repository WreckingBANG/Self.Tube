import 'package:Self.Tube/services/api_service.dart';
import 'package:Self.Tube/widgets/video_list_section.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/settings_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/channel_model.dart';
import '../services/api_service.dart';
import '../utils/number_formatter.dart';
import '../widgets/expandable_text.dart';


class ChannelpageScreen extends StatelessWidget{
  final String channelId;

  const ChannelpageScreen({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;


  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.channelTitle),
      ),
      body: 
      FutureBuilder<ChannelItemModel?>(
        future: ApiService.fetchChannel(channelId), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(localizations.errorFailedToLoadData));
          } else if (!snapshot.hasData) {
            return Center(child: Text(localizations.errorNoDataFound));
          } else {
            final channel = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: "$baseUrl/${channel.banner}",
                    httpHeaders: {
                      'Authorization': 'token $apiToken',
                    },
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  ListTile(
                    title: Text(channel.channelName),
                    subtitle: Text(formatNumberCompact(channel.subscribers, context)),
                    leading: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: "$baseUrl/${channel.profilePic}",
                          httpHeaders: {
                              'Authorization': 'token $apiToken',
                          },
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    trailing: channel.subscribed
                      ? FilledButton(
                          onPressed: () {},
                          child: Text(localizations.playerUnsubscribe),
                        )
                      : OutlinedButton(
                          onPressed: () {},
                          child: Text(localizations.playerSubscribe),
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: ExpandableText(channel.description),
                  ), 
                  VideoListSection(title: localizations.channelVideos, hideChannel: true, query: "?channel=${channelId}&order=desc&sort=published&type=videos")
                ],
              ),
            );
          }
        }
      )
    );
  }
}

