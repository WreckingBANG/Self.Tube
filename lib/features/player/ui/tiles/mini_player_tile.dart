import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/features/player/data/models/videoplayer_model.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:flutter/material.dart';

class MiniPlayerTile extends StatelessWidget {
  final Widget child;

  const MiniPlayerTile({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        ValueListenableBuilder<VideoPlayerModel?>(
          valueListenable: VideoPlayerService.currentVideo,
          builder: (context, video, _) {
            if (video == null) 
              return SizedBox.shrink();
              return GestureDetector(
                onTap: () { 
                  VideoPlayerService.openPlayer(context); 
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CustomNetwokImage(imageLink: video.videoThumbnail),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.videoTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                              Text(
                                video.channelName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          )
                        ),
                        StreamBuilder(
                          stream: VideoPlayerService.player?.playingStream,
                          initialData: VideoPlayerService.player?.isPlaying,
                          builder: (context, snapshot) {
                            final isP = snapshot.data ?? true; 
                            return IconButton(
                              color: Colors.white,
                              icon: Icon(
                                isP
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              ),
                              onPressed: () {
                                isP
                                  ? VideoPlayerService.player?.pause()
                                  : VideoPlayerService.player?.play();
                              },
                            );
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            VideoPlayerService.disposeVideo();
                          },
                        ),
                        SizedBox(width: 5)
                      ],
                    ),
                    StreamBuilder(
                      stream: VideoPlayerService.player?.positionStream,
                      initialData: VideoPlayerService.player?.position,
                      builder: (context, snapshot) {

                        final position = snapshot.data ?? Duration.zero; 
                        final duration = VideoPlayerService.player!.duration; 
                        final progress = duration.inMilliseconds == 0 
                          ? 0.0 
                          : position.inMilliseconds / duration.inMilliseconds;

                        return LinearProgressIndicator(
                          value: progress, 
                        );
                      }
                    )
                  ],
                )
             );
          },
        ),
      ],
    );
  }
}
