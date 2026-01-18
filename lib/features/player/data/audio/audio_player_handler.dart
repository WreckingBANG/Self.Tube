import 'package:audio_service/audio_service.dart';
import 'package:Self.Tube/features/player/domain/video_player_interface.dart';

class BackgroundAudioHandler extends BaseAudioHandler {
  static MediaPlayer? currentInternalPlayer;

  BackgroundAudioHandler() {
    playbackState.add(PlaybackState(
      controls: [],
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
  }

  @override
  Future<void> play() => currentInternalPlayer?.play() ?? Future.value();

  @override
  Future<void> pause() => currentInternalPlayer?.pause() ?? Future.value();

  @override
  Future<void> seek(Duration position) => currentInternalPlayer?.seek(position) ?? Future.value();

  @override
  Future<void> stop() async {
    await currentInternalPlayer?.pause();
    
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    
    return super.stop();
  }

  void syncStateWithPlayer(MediaPlayer player) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        player.isPlaying ? MediaControl.pause : MediaControl.play,
      ],
      systemActions: {
        MediaAction.seek, 
        MediaAction.pause, 
        MediaAction.play,
      },
      androidCompactActionIndices: const [0],
      playing: player.isPlaying,
      updatePosition: player.position,
      processingState: AudioProcessingState.ready,
    ));
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    return super.onTaskRemoved();
  }
}
