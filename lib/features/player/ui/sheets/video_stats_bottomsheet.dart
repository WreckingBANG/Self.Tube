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
          ListTile(
            title: Text("${localizations.statsBackend}: ${VideoPlayerService.player!.backend()}"),
          )
        ],
      ),
      ListSectionContainer(
        title: localizations.statsVideo,
        children: [
          ListTile(
            title: Text("${localizations.statsCodec}: ${video.codec}"),   
          ),
          ListTile(
            title: Text("${localizations.statsBitrate}: ${video.bitrate}"),
          ),
          ListTile(
            title: Text("${localizations.statsSize}: ${video.width} x ${video.height}")
          )
        ],
      ),
      ListSectionContainer(
        title: localizations.statsAudio,
        children: [
          ListTile(
            title: Text("${localizations.statsCodec}: ${audio.codec}"),
          ),
          ListTile(
            title: Text("${localizations.statsBitrate}: ${audio.bitrate}")
          )
        ],
      )
    ]
  );
}
