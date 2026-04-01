package com.wreckingbang.selftube

import android.media.MediaCodecList
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object CodecSupportChannel {
  private const val CHANNEL = "device.codec.support"

    fun register(flutterEngine: FlutterEngine) {
      MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
          CHANNEL
      ).setMethodCallHandler { call, result ->
        when (call.method) {
          "supportsCodec" -> {
              val codec = call.argument<String>("codec") ?: ""
              result.success(deviceSupportsCodec(codec))
          } else -> result.notImplemented()
        }
      }
    }

  private fun deviceSupportsCodec(mime: String): Boolean {
    val codecList = MediaCodecList(MediaCodecList.ALL_CODECS)
    val codecs = codecList.codecInfos

    for (codec in codecs) {
      if (!codec.isEncoder &&
        codec.supportedTypes.contains(mime) &&
        codec.isHardwareAccelerated
      ) {
        return true
      }
    }
    return false
  }
}
