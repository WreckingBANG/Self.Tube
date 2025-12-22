import 'package:Self.Tube/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/widgets/sections/channel_list_section.dart';
import 'package:flutter/material.dart';

class ChannelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshContainer(
        child: ListView(
          children: [
            ChannelListSection(query: "?filter=subscribed")
          ],
        )
      ),
    );
  }
}
