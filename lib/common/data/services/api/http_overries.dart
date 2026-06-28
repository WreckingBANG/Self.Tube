import 'dart:io';

import 'package:Self.Tube/common/data/services/settings/settings_service.dart';

class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return SettingsService.allowSelfSigned == true; 
      };
  }
}
