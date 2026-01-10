import 'package:flutter/material.dart';
import 'package:Self.Tube/domain/controllers/videolist_controller.dart';
import 'package:Self.Tube/ui/widgets/sections/sort_chips_section.dart';
import 'package:Self.Tube/ui/widgets/tiles/video_list_tile.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/ui/widgets/containers/list_section_container.dart';

class VideoListSection extends StatefulWidget {
  final String title;
  final bool hideChannel;
  final bool showSorting;
  final String query;
  final bool hideIfEmpty;

  const VideoListSection({
    super.key,
    this.title = "",
    required this.hideChannel,
    required this.query,
    this.hideIfEmpty = false,
    this.showSorting = false,
  });

  @override
  State<VideoListSection> createState() => _VideoListSectionState();
}

class _VideoListSectionState extends State<VideoListSection> {
  final controller = VideoListController(); 
  List videos = []; 
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchVideos(); 
  }

  Future<void> fetchVideos() async {
    if (isLoading || !controller.hasMore) return;

    setState(() => isLoading = true);

    final newVideos = await controller.fetchVideos(widget.query);

    setState(() {
      videos.addAll(newVideos);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ),
        if (widget.showSorting)
          SortChipsSection(
            sortOptions: (value) {
              setState(() {
                videos.clear();
                controller.reset(sort: value);
              });
              fetchVideos();
            },
          ),
        if (videos.isEmpty && widget.hideIfEmpty && !isLoading)
          const SizedBox.shrink()
        else if (videos.isEmpty && !widget.hideIfEmpty && !isLoading)
          Center(child: Text(localizations.errorNoDataFound))
        else
          ListSectionContainer(
            children: [
              ...List.generate(videos.length, (index) {
                final video = videos[index];
                return VideoListTile(video: video, hideChannel: widget.hideChannel);
              })
            ]
          ),
          
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (!isLoading && controller.hasMore && videos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextButton(
                onPressed: fetchVideos,
                child: Text(localizations.listShowMore),
              ),
            ),
          ),
      ],
    );
  }
}
