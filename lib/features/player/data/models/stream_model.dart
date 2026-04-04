class StreamSegment {
  final int bitrate;
  final String codec;
  final int? height;
  final int? width;
  final int index;
  final String type;

  StreamSegment({
    required this.bitrate,
    required this.codec,
    required this.index,
    required this.type,
    this.height,
    this.width,
  });

  factory StreamSegment.fromJson(Map<String, dynamic> json) {
    return StreamSegment (
      bitrate: json['bitrate'],
      codec: json['codec'],
      height: json['height'],
      width: json['width'],
      index: json['index'],
      type: json['type']
    );
  }
}

class Streams {
  final List<StreamSegment> streams;

  Streams ({
    required this.streams
  });

  factory Streams.fromJson(List<dynamic> json) {
    return Streams(
      streams: json.map((x) => StreamSegment.fromJson(x)).toList()
    );
  }

  List<StreamSegment> get videoStreams {
    return streams.where((s) => s.type == "video").toList();
  }

  StreamSegment? get video {
    return videoStreams.isNotEmpty
      ? videoStreams.first
      : null;
  }

  List<StreamSegment> get audioStreams {
    return streams.where((s) => s.type == "audio").toList();
  }

  StreamSegment? get audio {
    return audioStreams.isNotEmpty
      ? audioStreams.first
      : null;
  }
}
