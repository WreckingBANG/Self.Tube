import 'package:Self.Tube/core/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/features/channel/ui/sections/channel_list_section.dart';
import 'package:flutter/material.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

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
