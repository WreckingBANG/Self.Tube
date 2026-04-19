import 'package:Self.Tube/app/navigation/app_navigation.dart';
import 'package:Self.Tube/common/data/services/device/device_service.dart';
import 'package:Self.Tube/common/ui/widgets/containers/expandable_text.dart';
import 'package:Self.Tube/common/ui/widgets/media/custom_network_image.dart';
import 'package:Self.Tube/common/utils/datetime_formatter.dart';
import 'package:Self.Tube/common/utils/number_formatter.dart';
import 'package:Self.Tube/features/player/domain/video_player_service.dart';
import 'package:Self.Tube/features/player/ui/sections/player_info_section.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class PlayerScreen extends StatefulWidget {
final video;

const PlayerScreen({
  super.key,
  required this.video,
});

@override
State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  @override
  void initState() {
    super.initState();
    DeviceService.setWakeLock(true);
  }
  
  @override
  void dispose() {
    super.dispose();
    DeviceService.setWakeLock(false);
    DeviceService.resetBrightness(); 
  }
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [ 
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayerService.buildUI(
                      creator: widget.video.channelName,
                      title: widget.video.videoTitle
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExpandableText(
                    widget.video.videoTitle,
                    maxLines: 1,
                    textStyle: TextStyle(fontSize: 20),
                    showMoreText: false,
                  ), 
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("${formatNumberCompact(widget.video.videoViewCount, context)} ${localizations.playerViews}"),
                              const Text(" • "),
                              Text(formatDateTime(widget.video.videoDate, context)),
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.thumb_up, size: 15),
                              const SizedBox(width: 5),
                              Text(formatNumberCompact(widget.video.videoLikeCount, context)),
                              const Text(" • "),
                              const Icon(Icons.thumb_down, size: 15),
                              const SizedBox(width: 5),
                              Text(formatNumberCompact(widget.video.videoDislikeCount, context)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: Text(widget.video.channelName, style: TextStyle(fontSize: 16),),
                    subtitle: Text(formatNumberCompact(widget.video.channelSubCount, context)),
                    leading: SizedBox(
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomNetworkImage(
                            imageLink: widget.video.channelThumbUrl,
                            logicalWidth: 45,
                          )
                        ),
                      )
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        AppRouter.channelpageScreen,
                        arguments: widget.video.channelId
                      );
                    },
                  ),
                ]
              )
            ),
          )
        ],
        body: Padding(
          padding: EdgeInsets.only(top: 10),
          child: PlayerInfoSection(
            video: widget.video,
          )
        )
      )
    );
  }
}
