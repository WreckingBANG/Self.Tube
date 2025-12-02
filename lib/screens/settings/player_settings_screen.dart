import 'package:Self.Tube/widgets/containers/list_section_container.dart';
import 'package:flutter/material.dart';
import '../../services/settings_service.dart';
import '../../l10n/generated/app_localizations.dart';

class PlayerSettingsScreen extends StatefulWidget {
  @override
  _PlayerSettingsScreenState createState() => _PlayerSettingsScreenState();
}

class _PlayerSettingsScreenState extends State<PlayerSettingsScreen> {
  bool _vpGestureSwipe = false;
  bool _vpGestureFullscreen = false;
  bool _vpGesturePinch = false;
  bool _vpGestureDoubleTap = false;


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
  }

  Future<void> _saveSettings() async {
    await SettingsService.setVPGestureSwipe(_vpGestureSwipe);
    await SettingsService.setVPGestureFullscreen(_vpGestureFullscreen);
    await SettingsService.setVPGesturePinch(_vpGesturePinch);
    await SettingsService.setVPGestureDoubleTap(_vpGestureDoubleTap);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: ListSectionContainer(
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
    );
  }
}
