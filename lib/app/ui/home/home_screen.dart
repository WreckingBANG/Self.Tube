import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/features/videos/domain/videolist_provider.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_section.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final queryContinue = "?order=asc&watch=continue";
    final queryLatest = "?order=desc&sort=published&type=videos";

    if (SettingsService.disableHome == true) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/branding/selftube_icon_transparent.png',
                    width: 55,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    localizations.appTitle,
                    style: TextStyle(
                      fontSize: 40,

                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      AppRouter.search,
                    );
                  },
                  child: AbsorbPointer(
                    child: SearchBar(
                      leading: Icon(Icons.search),
                      hintText: localizations.tooltipSearch,
                    ),
                  ) 
                )
              )
            ],
          ),
        )
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(videoListProvider(queryContinue).notifier).refresh();
          ref.read(videoListProvider(queryLatest).notifier).refresh();
        },
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            VideoListSection(
              title: localizations.homeContinueWatching,
              hideChannel: false,
              hideIfEmpty: true,
              horizontalScroll: true,
              query: queryContinue 
            ),
            SizedBox(height: 16),
            VideoListSection(
              title: localizations.homeLatestVideos,
              hideChannel: false,
              showSorting: true,
              query: queryLatest
            ),
          ]
        ),
      ),
    );
  }
}
