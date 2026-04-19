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
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        ButtonRow(
          selectedItem: _controller.index,
          onSelected: (i) => _controller.animateTo(i),
          items: [
            ButtonRowItem(
              title: localizations.playerDescription,
              icon: Icons.description
            ),
            ButtonRowItem(
              title: localizations.playerComments,
              icon: Icons.comment
            ),
            ButtonRowItem(
              title: localizations.playerSimilar,
              icon: Icons.video_collection
            )
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SelectableLinkText(text: widget.video.videoDescription),
              ),
              
              CommentListWidget(videoId: widget.video.videoId),
              
              SingleChildScrollView(
                child: VideoListSimilarSection(
                  videoId: widget.video.videoId, 
                  query: ""
                )
              )
            ],
          ),
        )
      ],
    );
  }
} 
