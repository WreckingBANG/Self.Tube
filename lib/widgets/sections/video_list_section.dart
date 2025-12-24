import 'package:Self.Tube/services/api/video_api.dart';
import 'package:flutter/material.dart';
import '../tiles/video_list_tile.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';

class VideoListSection extends StatefulWidget {
  final String title;
  final bool hideChannel;
  final String query;
  final bool hideIfEmpty;

  const VideoListSection({
    super.key,
    this.title = "",
    required this.hideChannel,
    required this.query,
    this.hideIfEmpty = false,
  });

  @override
  State<VideoListSection> createState() => _VideoListSectionState();
}

class _VideoListSectionState extends State<VideoListSection> {
  List videos = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchVideos(); 
  }

  Future<void> fetchVideos() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final newVideos = await VideoApi().fetchVideoList("${widget.query}&page=$currentPage");

      if (newVideos != null) {
        setState(() {
          videos.addAll(newVideos.data);
          if (currentPage >= newVideos.lastPage) {
            hasMore = false;
          } else {
            currentPage++;
          }
        });
      } else {
        setState(() => hasMore = false);
      }
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (videos.isEmpty && widget.hideIfEmpty && !isLoading)
          const SizedBox.shrink() // do nothing
        else if (videos.isEmpty && !widget.hideIfEmpty && !isLoading)
          Center(child: Text(localizations.errorNoDataFound))
        else
          ListSectionContainer(
            title: widget.title,
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
        else if (!isLoading && hasMore && videos.isNotEmpty)
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
