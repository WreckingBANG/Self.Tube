
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';

class SponsorblockService  {
  static dynamic _video;
  static final _processedSegments = [];
  
  static void init(final video) {
    _video = video; 
    late final Map<String, bool> _categoryEnabledMap = {
      'sponsor': SettingsService.sbSponsor ?? false,
      'selfpromo': SettingsService.sbSelfpromo ?? false,
      'interaction': SettingsService.sbInteraction ?? false,
      'intro': SettingsService.sbIntro ?? false,
      'outro': SettingsService.sbOutro ?? false,
      'preview': SettingsService.sbPreview ?? false,
      'hook': SettingsService.sbHook ?? false,
      'filler': SettingsService.sbFiller ?? false,
    };
    
    for (final segment in _video.sponsorBlock?.segments ?? []) {
      for (final entry in _categoryEnabledMap.entries) {
        final categoryName = entry.key;
        final isEnabled = entry.value;
        
        if (isEnabled && segment.category.toLowerCase() == categoryName) {
          _processedSegments.add([
            categoryName,
            segment.segment[0].round(),
            segment.segment[1].round(),
          ]);
        }
      }
    }
  }

  static void checkTimestamp(Duration position) {
    for (final segment in _processedSegments ?? []) {
      final start = segment[1].round();
      final end = segment[2].round();
      //final category = segment.category.toLowerCase();
      //final segmentId = "$start-$end-$category";
      if (position.inSeconds >= start && position.inSeconds < end) {
        VideoPlayerService.player?.seek(Duration(seconds: end));
      } 
    }
  }

  static void dispose() {
    _video = null;
    _processedSegments.clear();
  }

}
