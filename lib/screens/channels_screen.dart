import 'package:Self.Tube/widgets/channel_list_tile.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../l10n/generated/app_localizations.dart';


class ChannelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self.Tube"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: localizations.searchTitle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: localizations.settingsTitle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
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
              return Column(
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
