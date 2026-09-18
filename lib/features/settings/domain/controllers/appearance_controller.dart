import 'package:Self.Tube/common/data/services/settings/settings_service.dart';

class AppearanceController {
  Future<bool> loadShowCommentPics() async {
    return SettingsService.showCommentPics ?? false;
  }

  Future<bool> loadMaterialYouColors() async {
    return SettingsService.materialYouColors ?? false;
  }

  Future<int> loadPaginationStyle() async {
    return SettingsService.paginationStyle ?? 0;
  }

  Future<void> setShowCommentPics(bool value) async {
    await SettingsService.setShowCommentPics(value);
  }

  Future<void> setMaterialYouColors(bool value) async {
    await SettingsService.setMaterialYouColors(value);
  }

  Future<void> setPaginationStyle(int value) async {
    await SettingsService.setPaginationStyle(value);
  }
}
