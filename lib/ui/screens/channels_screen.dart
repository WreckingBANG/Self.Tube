import 'package:flutter/material.dart';
import 'package:Self.Tube/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/ui/widgets/sections/channel_list_section.dart';

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
