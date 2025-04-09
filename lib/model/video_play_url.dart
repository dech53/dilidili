import 'package:json_annotation/json_annotation.dart';
part 'video_play_url.g.dart';

//supportformats结构体
@JsonSerializable()
class VideoPlayUrl {
  final String from;
  final String result;
  final String message;
  final int quality;
  final String format;

  @JsonKey(name: 'timelength')
  final int timeLength;

  @JsonKey(name: 'accept_format')
  final String acceptFormat;

  @JsonKey(name: 'accept_description')
  final List<String> acceptDescription;

  @JsonKey(name: 'accept_quality')
  final List<int> acceptQuality;

  @JsonKey(name: 'video_codecid')
  final int videoCodecId;

  @JsonKey(name: 'seek_param')
  final String seekParam;
  @JsonKey(name: 'seek_type')
  final String seekType;

  @JsonKey(name: 'support_formats')
  final List<dynamic> supportFormats;
  final Dash dash;
  @JsonKey(name: 'high_format')
  final dynamic highFormat;
  final int? lastPlayTime;
  final int? lastPlayCid;
  VideoPlayUrl({
    required this.from,
    required this.result,
    required this.message,
    required this.quality,
    required this.format,
    required this.timeLength,
    required this.acceptFormat,
    required this.acceptDescription,
    required this.acceptQuality,
    required this.videoCodecId,
    required this.seekParam,
    required this.seekType,
    //dash数组
    required this.dash,
    required this.supportFormats,
    required this.highFormat,
    this.lastPlayTime,
    this.lastPlayCid,
  });
  factory VideoPlayUrl.fromJson(Map<String, dynamic> json) =>
      _$VideoPlayUrlFromJson(json);
}

@JsonSerializable()
class Dash {
  final int duration;
  final double minBufferTime;

  @JsonKey(name: 'min_buffer_time')
  final double minBufferTimeAlt;
  final List<VADItem> video;
  final List<VADItem>? audio;
  final Dolby? dolby;
  final Flac? flac;

  Dash({
    required this.duration,
    required this.minBufferTime,
    required this.minBufferTimeAlt,
    required this.video,
    this.audio,
    this.dolby,
    this.flac,
  });
  factory Dash.fromJson(Map<String, dynamic> json) => _$DashFromJson(json);
}

@JsonSerializable()
class VADItem {
  final int id;
  final String baseUrl;
  final String base_url;
  final List<String> backupUrl;
  final List<String> backup_url;
  final int bandwidth;
  final String mimeType;
  final String mime_type;
  final String codecs;
  final int? width;
  final int? height;
  final String? frameRate;
  final String? frame_rate;
  final String? sar;
  final int? startWithSap;
  final int? start_with_sap;
  @JsonKey(name: 'SegmentBase')
  SegmentBase? segmentBase;
  SegmentBase? segment_base;
  final int codecid;
  VADItem({
    required this.id,
    required this.baseUrl,
    required this.base_url,
    required this.backupUrl,
    required this.backup_url,
    required this.bandwidth,
    required this.mimeType,
    required this.mime_type,
    required this.codecs,
    this.width,
    this.height,
    this.frameRate,
    this.frame_rate,
    this.sar,
    this.startWithSap,
    this.start_with_sap,
    this.segmentBase,
    this.segment_base,
    required this.codecid,
  });
  factory VADItem.fromJson(Map<String, dynamic> json) =>
      _$VADItemFromJson(json);
}

@JsonSerializable()
class SegmentBase {
  final String? initialization;

  @JsonKey(name: 'index_range')
  final String? indexRange;

  SegmentBase({
    this.initialization,
    this.indexRange,
  });
  factory SegmentBase.fromJson(Map<String, dynamic> json) =>
      _$SegmentBaseFromJson(json);
}

@JsonSerializable()
class Dolby {
  int type;
  List<VADItem>? audio;
  Dolby({
    required this.type,
    this.audio,
  });
  factory Dolby.fromJson(Map<String, dynamic> json) => _$DolbyFromJson(json);
}

@JsonSerializable()
class Flac {
  bool display;
  List<VADItem>? audio;
  Flac({required this.display, this.audio});
  factory Flac.fromJson(Map<String, dynamic> json) => _$FlacFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoOnlinePeople {
  String total;
  String count;
  ShowSwitch showSwitch;
  VideoOnlinePeople(
      {required this.total, required this.count, required this.showSwitch});
  factory VideoOnlinePeople.fromJson(Map<String, dynamic> json) =>
      _$VideoOnlinePeopleFromJson(json);
}

@JsonSerializable()
class ShowSwitch {
  bool total;
  bool count;
  ShowSwitch({required this.total, required this.count});
  factory ShowSwitch.fromJson(Map<String, dynamic> json) =>
      _$ShowSwitchFromJson(json);
}
