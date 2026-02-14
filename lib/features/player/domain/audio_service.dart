import 'package:Self.Tube/features/player/domain/video_player_interface.dart';
import 'package:audio_service/audio_service.dart';

class MediaSessionHandler extends BaseAudioHandler {
  late MediaPlayer _player;

  static Future<MediaSessionHandler> create() async {
    return await AudioService.init(
      builder: () => MediaSessionHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.wreckingbang.selftube.channel.audio',
        androidNotificationChannelName: 'Audio Playback',
        androidStopForegroundOnPause: true,
      ),
    );
  }

  MediaSessionHandler() {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.play
        ],
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }

  void attachPlayer(MediaPlayer player) {
    _player = player;

    _player.playingStream.listen((_) => _updateState());
    _player.positionStream.listen((_) => _updateState());
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  void _updateState() {
    playbackState.add(
      PlaybackState(
        controls: [
          _player.isPlaying ? MediaControl.pause : MediaControl.play,
        ],
        systemActions: {
          MediaAction.seek, 
			    MediaAction.pause, 
			    MediaAction.play,
        },
        androidCompactActionIndices: const [0],
        processingState: AudioProcessingState.ready,
        playing: _player.isPlaying,
        updatePosition: _player.position,
      ),
    );
  }

  void updateMetadata(dynamic video) {
    mediaItem.add(
      MediaItem(
        id: video.value!.videoId,
        title: video.value!.videoTitle,
        artist: video.value!.channelName,
        duration: video.duration
      )
    );
  }


  void dispose() {
    playbackState.add(
      PlaybackState(
        controls: [],
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero
      )
    );
  } 
}

