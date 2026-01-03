import 'package:Self.Tube/services/api/channel_api.dart';
import 'package:Self.Tube/widgets/sections/video_list_section.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/settings_service.dart';
import '../models/channel/channel_model.dart';
import '../utils/number_formatter.dart';
import '../widgets/containers/expandable_text.dart';
import 'package:Self.Tube/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/widgets/media/images/custom_network_image.dart';


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
      body: RefreshContainer(
        child: FutureBuilder<ChannelItemModel?>(
          future: ChannelApi().fetchChannel(channelId), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(localizations.errorFailedToLoadData));
            } else if (!snapshot.hasData) {
              return Center(child: Text(localizations.errorNoDataFound));
            } else {
              final channel = snapshot.data!;
              return ListView(
                children: [
                  Column(
                    children: [
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
                              onPressed: () {},
                              child: Text(localizations.playerUnsubscribe),
                            )
                          : OutlinedButton(
                              onPressed: () {},
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
                      VideoListSection(title: localizations.channelVideos, showSorting: true, hideChannel: true, query: "?channel=${channelId}&order=desc&sort=published&type=videos")
                    ],
                  )
                ]
              );
            }
          }
        )
      )
    );
  }
}

