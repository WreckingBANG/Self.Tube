import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/settings/domain/controllers/appearance_controller.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  _AppearanceSettingsScreenState createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  final controller = AppearanceController();

  bool _showCommentPics = false;
  bool _materialYouColors = false;
  int _paginationStyle = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final pics = await controller.loadShowCommentPics();
    final colors = await controller.loadMaterialYouColors();
    final pagination = await controller.loadPaginationStyle();

    setState(() {
      _showCommentPics = pics;
      _materialYouColors = colors;
      _paginationStyle = pagination;
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
          ListTile(
            title: Text("Pagination Style"),
            leading: Icon(Symbols.auto_stories),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text(localizations.settingsVPPlayerBackendDesc),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: [
                      ButtonSegment(
                        value: 0,
                        label: Text(
                          "Pages (Default)",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        )
                      ),
                      ButtonSegment(
                        value: 1, 
                        label: Text("Show More")
                      ),
                    ], 
                    selected: {_paginationStyle},
                    onSelectionChanged: (value) {
                      setState(() {
                        controller.setPaginationStyle(value.first);
                        _paginationStyle = value.first;
                      });
                    },
                  )
                ),
              ]
            )
          )
        ],
      ),
    );
  }
}
