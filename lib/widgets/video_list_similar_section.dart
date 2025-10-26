import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'video_list_tile.dart';

class VideoListSimilarSection extends StatefulWidget {
  final String videoId;
  final String query;

  const VideoListSimilarSection({
    super.key,
    required this.videoId,
    required this.query,
  });

  @override
  State<VideoListSimilarSection> createState() => _VideoListSimilarSectionState();
}

class _VideoListSimilarSectionState extends State<VideoListSimilarSection> {
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
    final newVideos = await ApiService.fetchSimilarVideoList(widget.videoId);
    
    setState(() {
      if (newVideos == null || newVideos.isEmpty) {
        hasMore = false;
      } else {
        videos.addAll(newVideos);
        currentPage++;
      }
      isLoading = false;
    });

  }

@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (videos.isEmpty && isLoading)
          const Center(child: CircularProgressIndicator())
        else if (videos.isEmpty)
          const Center(child: Text("No data found."))
        else
          ...videos.map((video) => VideoListTile(video: video)).toList(),
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
                child: const Text("Show More"),
              ),
            ),
          ),
      ],
    );
  }
}
