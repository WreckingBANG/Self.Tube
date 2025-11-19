import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'video_list_tile.dart';
import '../l10n/generated/app_localizations.dart';

class VideoListSection extends StatefulWidget {
  final String title;
  final bool hideChannel;
  final String query;

  const VideoListSection({
    super.key,
    required this.title,
    required this.hideChannel,
    required this.query,
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
      final newVideos = await ApiService.fetchVideoList("${widget.query}&page=$currentPage");

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        if (videos.isEmpty && isLoading)
          const Center(child: CircularProgressIndicator())
        else if (videos.isEmpty)
          Center(child: Text(localizations.errorNoDataFound))
        else
          ...videos.map((video) => VideoListTile(video: video,hideChannel: widget.hideChannel)).toList(),
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
