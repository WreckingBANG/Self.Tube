import 'dart:io';
import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class PlayerSettingsScreen extends StatefulWidget {
  const PlayerSettingsScreen({super.key});

  @override
  _PlayerSettingsScreenState createState() => _PlayerSettingsScreenState();
}

class _PlayerSettingsScreenState extends State<PlayerSettingsScreen> {
  bool _vpGestureSwipe = false;
  bool _vpGestureFullscreen = false;
  bool _vpGesturePinch = false;
  bool _vpGestureDoubleTap = false;
  int _playerBackend = 0;


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _vpGestureSwipe = SettingsService.vpGestureSwipe ?? false;
    _vpGestureFullscreen = SettingsService.vpGestureFullscreen ?? false;
    _vpGesturePinch = SettingsService.vpGesturePinch ?? false;
    _vpGestureDoubleTap = SettingsService.vpGestureDoubleTap ?? false;
    _playerBackend = SettingsService.playerBackend ?? 0;
  }

  Future<void> _saveSettings() async {
    await SettingsService.setVPGestureSwipe(_vpGestureSwipe);
    await SettingsService.setVPGestureFullscreen(_vpGestureFullscreen);
    await SettingsService.setVPGesturePinch(_vpGesturePinch);
    await SettingsService.setVPGestureDoubleTap(_vpGestureDoubleTap);
    await SettingsService.setPlayerBackend(_playerBackend);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListSectionContainer(
              title: localizations.settingsVPGesturesTitle,
              children: [
                SwitchListTile(
                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.check);
                      }
                      return const Icon(Icons.close);
                    },
                  ),
                  title: Text(localizations.settingsVPGesturesSwipeCtrl),
                  subtitle: Text(localizations.settingsVPGesturesSwipeCtrlDesc),
                  secondary: const Icon(Icons.swipe_vertical_rounded),
                  value: _vpGestureSwipe,
                  onChanged: (bool value) {
                    setState(() {
                      _vpGestureSwipe = value;
                      _saveSettings();
                    });
                  },
                ),
                SwitchListTile(
                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.check);
                      }
                      return const Icon(Icons.close);
                    },
                  ),
                  title: Text(localizations.settingsVPGesturesFullscreen),
                  subtitle: Text(localizations.settingsVPGesturesFullscreenDesc),
                  secondary: const Icon(Icons.fullscreen_exit),
                  value: _vpGestureFullscreen,
                  onChanged: (bool value) {
                    setState(() {
                      _vpGestureFullscreen = value;
                      _saveSettings();
                    });
                  },
                ),
                SwitchListTile(
                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.check);
                      }
                      return const Icon(Icons.close);
                    },
                  ),
                  title: Text(localizations.settingsVPGesturesPinch),
                  subtitle: Text(localizations.settingsVPGesturesPinchDesc),
                  secondary: const Icon(Icons.pinch_rounded),
                  value: _vpGesturePinch,
                  onChanged: (bool value) {
                    setState(() {
                      _vpGesturePinch = value;
                      _saveSettings();
                    });
                  },
                ),
                SwitchListTile(
                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.check);
                      }
                      return const Icon(Icons.close);
                    },
                  ),
                  title: Text(localizations.settingsVPGesturesDoubleTap),
                  subtitle: Text(localizations.settingsVPGesturesDoubleTapDesc),
                  secondary: const Icon(Icons.touch_app_rounded),
                  value: _vpGestureDoubleTap,
                  onChanged: (bool value) {
                    setState(() {
                      _vpGestureDoubleTap = value;
                      _saveSettings();
                    });
                  },
                )
              ]
            ),
            if (Platform.isAndroid)
              ListSectionContainer(
                title: localizations.settingsVPAdvanded,
                children: [
                ListTile(
                  title: Text(localizations.settingsVPPlayerBackend),
                  leading: Icon(Icons.video_settings),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localizations.settingsVPPlayerBackendDesc), 
                      SegmentedButton<int>(
                        segments: [
                          ButtonSegment(
                            value: 0,
                            label: Text(localizations.settingsVPPlayerBackendDyn)
                          ),
                          ButtonSegment(
                            value: 1, 
                            label: Text("EXO")
                          ),
                          ButtonSegment(
                            value: 2,
                            label: Text("MPV")
                          )
                        ], 
                        selected: {_playerBackend},
                        onSelectionChanged: (value) {
                          setState(() {
                            _playerBackend = value.first;
                            _saveSettings();
                          });
                        },
                      ),
                    ]
                  )
                )
              ]
            )
          ],
        ),
      )
    );
  }
}
