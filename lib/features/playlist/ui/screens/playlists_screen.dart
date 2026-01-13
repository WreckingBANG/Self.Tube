import 'package:Self.Tube/core/ui/widgets/containers/refresh_container.dart';
import 'package:Self.Tube/features/playlist/ui/sections/playlist_list_section.dart';
import 'package:flutter/material.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

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
