import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/settings/domain/controllers/distractions_controller.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class DistractionsSettingsScreen extends StatefulWidget {
  const DistractionsSettingsScreen({super.key});

  @override
  _DistractionsSettingsScreenState createState() => _DistractionsSettingsScreenState();
}

class _DistractionsSettingsScreenState extends State<DistractionsSettingsScreen> {
  final controller = DistractionsController();

  bool _disableRecommendations = false;
  bool _disableComments = false;
  bool _disableHome = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final recommendations = await controller.loadDisableRecommendations();
    final comments = await controller.loadDisableComments();
    final home = await controller.loadDisableHome();

    setState(() {
      _disableRecommendations = recommendations;
      _disableComments = comments;
      _disableHome = home;
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
            title: Text("Disable Recommendations"),
            value: _disableRecommendations,
            onChanged: (bool value) {
              setState(() => _disableRecommendations = value);
              controller.setDisableRecommendations(value);
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
            title: Text("Disable Comments"),
            value: _disableComments,
            onChanged: (bool value) {
              setState(() => _disableComments = value);
              controller.setDisableComments(value);
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
            title: Text("Disable Home"),
            value: _disableHome,
            onChanged: (bool value) {
              setState(() => _disableHome = value);
              controller.setDisableHome(value);
            },
          ),
        ],
      ),
    );
  }
}
