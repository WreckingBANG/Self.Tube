import 'dart:io';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DeviceService {
  static late final VolumeController _volume;

  static Future<void> init() async {
    _volume = VolumeController.instance;
    _volume.showSystemUI = false; 
  } 
  
  static Future<void> setFullScreen(bool value) async {
    if(Platform.isAndroid && value){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else if (Platform.isAndroid && !value){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else if (Platform.isLinux){
      windowManager.setFullScreen(value);
    }
  }

  static Future<void> showSystemUI(bool value) async {
    if(Platform.isAndroid && value){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else if (Platform.isAndroid && !value){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  static Future<void> setWakeLock(bool value) async {
    WakelockPlus.toggle(enable: value);
  }

  static Future<void> setBrightness(double value) async {
    if(Platform.isAndroid){
      ScreenBrightness().setApplicationScreenBrightness(value);
    }
  }

  static Future<double?> getBrightness() async {
    if(Platform.isAndroid){
      return ScreenBrightness().application;
    } else {
      return 0;
    }
  }

  static Future<void> resetBrightness() async {
    if(Platform.isAndroid) {
      return ScreenBrightness().resetApplicationScreenBrightness();
    }
  }

  static Future<void> setVolume(double value) async {
    _volume.setVolume(value);
  }

  static Future<double?> getVolume() async {
    return _volume.getVolume();
  }
}
