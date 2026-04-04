import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

Future<void> showVideoStatsBottomSheet({
  required BuildContext context,
  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  final streams = VideoPlayerService.currentVideo.value!.streams;
  final video = streams.video!;
  final audio = streams.audio!;
  return showBottomSheetTemplate(
    context: context, 
    children: [
      ListSectionContainer(
        title: localizations.playerTitle,
        children: [
          Padding(
            padding: EdgeInsets.all(5), 
            child: Text("${localizations.statsBackend}: ${VideoPlayerService.player!.backend()}")
          )
        ],
      ),
      ListSectionContainer(
        title: localizations.statsVideo,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("${localizations.statsCodec}: ${video.codec}"),   
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("${localizations.statsBitrate}: ${video.bitrate}"),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("${localizations.statsSize}: ${video.width} x ${video.height}")
          )
        ],
      ),
      ListSectionContainer(
        title: localizations.statsAudio,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("${localizations.statsCodec}: ${audio.codec}"),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("${localizations.statsBitrate}: ${audio.bitrate}")
          )
        ],
      )
    ]
  );
}
