import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/sheets/bottomsheet_template.dart';
import 'package:Self.Tube/features/player/domain/video_player_interface.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

Future<void> showVideoPlayerBottomSheet({
  required BuildContext context,
  required MediaPlayer player,
  String? title,
}) {
  final localizations = AppLocalizations.of(context)!;
  return showBottomSheetTemplate(
    context: context, 
    children: [
      ListSectionContainer(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: player.repeatNotifier,
            builder: (context, repeat, _) {
              return SwitchListTile(
                secondary: Icon(Icons.repeat_rounded),
                title: Text(localizations.playerRepeat),
                value: repeat,
                onChanged: (value) => player.setRepeat(value),
                thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Icon(Icons.check);
                    }
                    return const Icon(Icons.close);
                  },
                ),
              );
            },
          ),
          ValueListenableBuilder<BorderMode>(
            valueListenable: player.borderModeNotifier,
            builder: (context, mode, _) {
              return ListTile(
                title: Text(localizations.playerBorderMode),
                leading: Icon(Icons.fit_screen_rounded),
                trailing: DropdownButton<BorderMode>(
                  value: mode,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: BorderMode.contain,
                      child: Text(localizations.playerBorderModeContain),
                    ),
                    DropdownMenuItem(
                      value: BorderMode.cover,
                      child: Text(localizations.playerBorderModeCover),
                    ),
                    DropdownMenuItem(
                      value: BorderMode.stretch,
                      child: Text(localizations.playerBorderModeStretch),
                    ),
                  ],
                  onChanged: (value) => player.setBorderMode(value!),
                ),
              );
            },
          ),
          ValueListenableBuilder<PlaybackSpeed>(
            valueListenable: player.speedNotifier,
            builder: (context, speed, _) {
              return ListTile(
                leading: Icon(Icons.speed),
                title: Text(localizations.playerPlaybackSpeed),
                trailing: DropdownButton<PlaybackSpeed>(
                  value: speed,
                  underline: const SizedBox(),
                  isDense: true,
                  items: PlaybackSpeed.values.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text("${s.value}x"),
                    );
                  }).toList(),
                  onChanged: (value) => player.setPlaybackSpeed(value!),
                ),
              );
            },
          ),
        ],
      )
    ]
  );
}
