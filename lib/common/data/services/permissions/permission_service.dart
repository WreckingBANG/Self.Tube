

import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  static Future<PermissionStatus> checkLocalNetworkPermission() async {
    return await Permission.accessLocalNetwork.status;
  }

  static Future<PermissionStatus> requestLocalNetworkPermission() async {
    return await Permission.accessLocalNetwork.request();
  }

}
