import 'package:flutter/services.dart';

class CodecSupport {
  static const MethodChannel _channel = MethodChannel("device.codec.support");

  static Future<bool> supports(String mime) async {
    final result = await _channel.invokeMethod("supportsCodec", {
      "codec": mime,
    });
    return result == true;
  }
}
