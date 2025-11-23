import 'package:flutter/material.dart';
import '../widgets/sections/video_list_section.dart';
import '../l10n/generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Key _contentKey = UniqueKey();

  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _contentKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            key: _contentKey,
            children: [
              VideoListSection(
                title: localizations.homeContinueWatching,
                hideChannel: false,
                query: "?order=asc&sort=published&watch=continue",
              ),
              SizedBox(height: 16),
              VideoListSection(
                title: localizations.homeLatestVideos,
                hideChannel: false,
                query: "?order=desc&sort=published&type=videos",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
