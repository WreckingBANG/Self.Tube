import 'package:Self.Tube/widgets/sections/playlist_list_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/widgets/containers/refresh_container.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshContainer(
        child: ListView(
          children: [
            PlaylistListSection()
          ],
        )
      ),
    );
  }
}
