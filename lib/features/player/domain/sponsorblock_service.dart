import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/global_snackbar.dart';
import 'package:Self.Tube/common/utils/duration_formatter.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

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
            false
          ]);
        }
      }
    }
  }

  static void checkTimestamp(Duration position) {
    for (var i = 0; i < (_processedSegments).length; i++) {
      final segment = _processedSegments[i];
      final start = segment[1].round();
      final end = segment[2].round();
      final category = segment[0].toLowerCase();

      if (position.inSeconds >= start && position.inSeconds < end && !segment[3]) {
        VideoPlayerService.player?.seek(Duration(seconds: end));
        showSnackBar(category, start, end, i);
      } 
    }
  }
  
  static void showSnackBar(String category, int start, int end, int i) {
    final localizations = AppLocalizations.of(GlobalSnackbar.key.currentContext!);
    print("test");
    GlobalSnackbar.show(
      localizations!.playerSBSkipped(category, formatDuration(end), formatDuration(start)),
      actionLabel: localizations.playerSBUndo,
      icon: Icons.money_off,
      onAction: () {
        _processedSegments[i][3] = true;
        VideoPlayerService.player?.seek(Duration(seconds: start-1)); 
      }
    );
  }

  static void dispose() {
    _video = null;
    _processedSegments.clear();
  }

}
