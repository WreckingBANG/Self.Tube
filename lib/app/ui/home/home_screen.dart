import 'package:Self.Tube/features/videos/domain/providers/videolist_provider.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_section.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final queryContinue = "?order=asc&sort=published&watch=continue";
    final queryLatest = "?order=desc&sort=published&type=videos"; 

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(videoListProvider(queryContinue));
          ref.invalidate(videoListProvider(queryLatest));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                VideoListSection(
                  title: localizations.homeContinueWatching,
                  hideChannel: false,
                  hideIfEmpty: true,
                  query: queryContinue 
                ),
                SizedBox(height: 16),
                VideoListSection(
                  title: localizations.homeLatestVideos,
                  hideChannel: false,
                  showSorting: true,
                  query: queryLatest
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}
