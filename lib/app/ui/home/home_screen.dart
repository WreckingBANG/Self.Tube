import 'package:flutter/material.dart';
import 'package:Self.Tube/common/ui/widgets/sections/video_list_section.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/common/ui/widgets/containers/refresh_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: RefreshContainer(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                VideoListSection(
                  title: localizations.homeContinueWatching,
                  hideChannel: false,
                  hideIfEmpty: true,
                  query: "?order=asc&sort=published&watch=continue",
                ),
                SizedBox(height: 16),
                VideoListSection(
                  title: localizations.homeLatestVideos,
                  hideChannel: false,
                  showSorting: true,
                  query: "?order=desc&sort=published&type=videos",
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}
