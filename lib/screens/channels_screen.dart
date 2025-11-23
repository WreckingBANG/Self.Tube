import 'package:Self.Tube/widgets/tiles/channel_list_tile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';


class ChannelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<List?>(
          future: ApiService.fetchChannelList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(localizations.errorFailedToLoadData));
            } else if (!snapshot.hasData) {
              return Center(child: Text(localizations.errorNoDataFound));
            } else {
              final channel = snapshot.data!;
              return ListSectionContainer(
                children: [
                  ...List.generate(channel.length, (index) {
                    return ChannelListTile(channel: channel[index]);
                  }),
                ],
              );
            }
          },
        ),
      )
    );
  }
}
