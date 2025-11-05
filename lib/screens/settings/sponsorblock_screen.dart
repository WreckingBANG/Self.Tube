import 'package:flutter/material.dart';
import '../../services/settings_service.dart';
import '../../l10n/generated/app_localizations.dart';

class SponsorblockSettingsScreen extends StatefulWidget {
  @override
  _SponsorblockSettingsScreenState createState() => _SponsorblockSettingsScreenState();
}

class _SponsorblockSettingsScreenState extends State<SponsorblockSettingsScreen> {
  bool _enableSponsorblock = false;
  bool _enableSponsor = false;
  bool _enablePromo = false;
  bool _enableInteraction = false;
  bool _enableIntro = false;
  bool _enableOutro = false;
  bool _enablePreview = false;
  bool _enableHook = false;
  bool _enableFiller = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _enableSponsorblock = SettingsService.sponsorBlockEnabled ?? false;
    _enableSponsor = SettingsService.sbSponsor ?? false;
    _enablePromo = SettingsService.sbSelfpromo ?? false;
    _enableInteraction = SettingsService.sbInteraction ?? false;
    _enableIntro = SettingsService.sbIntro ?? false;
    _enableOutro = SettingsService.sbOutro ?? false;
    _enablePreview = SettingsService.sbPreview ?? false;
    _enableHook = SettingsService.sbHook ?? false;
    _enableFiller = SettingsService.sbFiller ?? false;
  }

  Future<void> _saveSettings() async {
    final localizations = AppLocalizations.of(context)!;
    await SettingsService.setSponsorBlockEnabled(_enableSponsorblock);
    await SettingsService.setSponsorCategory("sbSponsor", _enableSponsor);
    await SettingsService.setSponsorCategory("sbSelfpromo", _enablePromo);
    await SettingsService.setSponsorCategory("sbInteraction", _enableInteraction);
    await SettingsService.setSponsorCategory("sbIntro", _enableIntro);
    await SettingsService.setSponsorCategory("sbOutro", _enableOutro);
    await SettingsService.setSponsorCategory("sbPreview", _enablePreview);
    await SettingsService.setSponsorCategory("sbHook", _enableHook);
    await SettingsService.setSponsorCategory("sbFiller", _enableFiller);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(localizations.sponsorblockEnable),
              value: _enableSponsorblock,
              onChanged: (bool value) {
                setState(() {
                  _enableSponsorblock = value;
                  _saveSettings();
                });
              },
            ),
            IgnorePointer(
              ignoring: !_enableSponsorblock,
              child: Opacity(
                opacity: _enableSponsorblock ? 1.0 : 0.4,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(localizations.sponsorblockSponsor),
                      value: _enableSponsor,
                      onChanged: (bool value) {
                        setState(() {
                          _enableSponsor = value;
                          _saveSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(localizations.sponsorblockPromo),
                      value: _enablePromo,
                      onChanged: (bool value) {
                        setState(() {
                          _enablePromo = value;
                          _saveSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(localizations.sponsorblockInteraction),
                      value: _enableInteraction,
                      onChanged: (bool value) {
                        setState(() {
                          _enableInteraction = value;
                          _saveSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(localizations.sponsorblockIntro),
                      value: _enableIntro,
                      onChanged: (bool value) {
                        setState(() {
                          _enableIntro = value;
                          _saveSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(localizations.sponsorblockOutro),
                      value: _enableOutro,
                      onChanged: (bool value) {
                        setState(() {
                          _enableOutro = value;
                          _saveSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(localizations.sponsorblockPreview),
                      value: _enablePreview,
                      onChanged: (bool value) {
                        setState(() {
                          _enablePreview = value;
                          _saveSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(localizations.sponsorblockHook),
                      value: _enableHook,
                      onChanged: (bool value) {
                        setState(() {
                          _enableHook = value;
                          _saveSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(localizations.sponsorblockFiller),
                      value: _enableFiller,
                      onChanged: (bool value) {
                        setState(() {
                          _enableFiller = value;
                          _saveSettings();
                        });
                      },
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
