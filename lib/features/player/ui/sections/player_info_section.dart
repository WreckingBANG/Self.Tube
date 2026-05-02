import 'package:Self.Tube/common/ui/widgets/buttons/button_row.dart';
import 'package:Self.Tube/common/ui/widgets/containers/selectable_text.dart';
import 'package:Self.Tube/features/videos/ui/sections/comment_list_section.dart';
import 'package:Self.Tube/features/videos/ui/sections/video_list_similar_section.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
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
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this
    );

    _controller.addListener(() {
      setState(() {});      
    });
  }

  
  @override
  Widget build (BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controller,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              icon: const Icon(Icons.description_outlined),
              //text: localizations.playerDescription,
            ),
            Tab(
              icon: const Icon(Icons.comment_outlined),
              //text: localizations.playerComments,
            ),
            Tab(
              icon: const Icon(Icons.video_collection_outlined),
              //text: localizations.playerSimilar,
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: SelectableLinkText(text: widget.video.videoDescription),
              ),
              
              CommentListWidget(videoId: widget.video.videoId),
              
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: SingleChildScrollView(
                child: VideoListSimilarSection(
                  videoId: widget.video.videoId, 
                  query: ""
                  )
                )
              ) 
            ],
          ),
        )
      ],
    );
  }
} 
