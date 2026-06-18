import 'package:Self.Tube/common/data/services/settings/settings_service.dart';

class DistractionsController {
  Future<bool> loadDisableRecommendations() async {
    return SettingsService.disableRecommendations ?? false;
  }

  Future<bool> loadDisableComments() async {
    return SettingsService.disableComments ?? false;
  }

  Future<bool> loadDisableHome() async {
    return SettingsService.disableHome ?? false;
  }
  
  Future<void> setDisableRecommendations(bool value) async {
    await SettingsService.setDisableRecommendations(value);
  }

  Future<void> setDisableComments(bool value) async {
    await SettingsService.setDisableComments(value);
  }

  Future<void> setDisableHome(bool value) async {
    await SettingsService.setDisableHome(value);
  }
}
