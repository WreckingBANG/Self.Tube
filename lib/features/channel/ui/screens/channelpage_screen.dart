import 'package:Self.Tube/core/data/services/settings/settings_service.dart';
import 'package:Self.Tube/core/ui/widgets/containers/expandable_text.dart';
import 'package:Self.Tube/core/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/core/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/core/ui/widgets/sections/video_list_section.dart';
import 'package:Self.Tube/core/utils/number_formatter.dart';
import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:Self.Tube/features/channel/data/models/channel_model.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';


class ChannelpageScreen extends StatelessWidget{
  final String channelId;

  const ChannelpageScreen({
    super.key,
    required this.channelId,
  });

  static String? apiToken = SettingsService.apiToken;
  static String? baseUrl = SettingsService.instanceUrl;


  @override
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
                      VideoListSection(title: localizations.channelVideos, showSorting: true, hideChannel: true, query: "?channel=$channelId&order=desc&sort=published&type=videos")
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

