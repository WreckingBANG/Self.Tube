import 'package:Self.Tube/core/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/settings/domain/controllers/appearance_controller.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  _AppearanceSettingsScreenState createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  final controller = AppearanceController();

  bool _showCommentPics = false;
  bool _materialYouColors = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final pics = await controller.loadShowCommentPics();
    final colors = await controller.loadMaterialYouColors();

    setState(() {
      _showCommentPics = pics;
      _materialYouColors = colors;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: ListSectionContainer(
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
            title: Text(localizations.settingsShowCommentPics),
            value: _showCommentPics,
            onChanged: (bool value) {
              setState(() => _showCommentPics = value);
              controller.setShowCommentPics(value);
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
            title: Text(localizations.settingsM3Colors),
            value: _materialYouColors,
            onChanged: (bool value) {
              setState(() => _materialYouColors = value);
              controller.setMaterialYouColors(value);
            },
          ),
        ],
      ),
    );
  }
}
