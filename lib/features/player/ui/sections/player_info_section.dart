import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/widgets/containers/selectable_text.dart';
import 'package:Self.Tube/features/videos/ui/sections/comment_list_section.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_similar_section.dart';
import 'package:flutter/material.dart';

class PlayerInfoSection extends StatefulWidget {
  final dynamic video;

  PlayerInfoSection ({
    super.key,
    required this.video,
  });

  @override
  _PlayerInfoSectionState createState() => _PlayerInfoSectionState();
}

class _PlayerInfoSectionState extends State<PlayerInfoSection> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build (BuildContext context) {

    final tabs = [
      Tab(
        icon: const Icon(Icons.description_outlined),
        //text: localizations.playerDescription,
      ),
      
      if (SettingsService.disableComments != true)
        Tab(
          icon: const Icon(Icons.comment_outlined),
          //text: localizations.playerComments,
        ),
      
      if (SettingsService.disableRecommendations != true) 
        Tab(
          icon: const Icon(Icons.video_collection_outlined),
          //text: localizations.playerSimilar,
        ),
    ];

    final tabViews = [
      Padding(
        padding: EdgeInsets.all(12),
        child: SelectableLinkText(text: widget.video.videoDescription),
      ),

      if (SettingsService.disableComments != true)
        CommentListWidget(videoId: widget.video.videoId),
      
      
      if (SettingsService.disableRecommendations != true) 
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: VideoListSimilarSection(
            videoId: widget.video.videoId, 
            query: ""
          )
        )
    ];
    
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            tabs: tabs
          ),
          Expanded(
            child: TabBarView(
              children: tabViews
            ),
          )
        ],
      ),
    );
  }
} 
