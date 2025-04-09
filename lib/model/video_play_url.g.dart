// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_play_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPlayUrl _$VideoPlayUrlFromJson(Map<String, dynamic> json) => VideoPlayUrl(
      from: json['from'] as String,
      result: json['result'] as String,
      message: json['message'] as String,
      quality: (json['quality'] as num).toInt(),
      format: json['format'] as String,
      timeLength: (json['timelength'] as num).toInt(),
      acceptFormat: json['accept_format'] as String,
      acceptDescription: (json['accept_description'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      acceptQuality: (json['accept_quality'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      videoCodecId: (json['video_codecid'] as num).toInt(),
      seekParam: json['seek_param'] as String,
      seekType: json['seek_type'] as String,
      dash: Dash.fromJson(json['dash'] as Map<String, dynamic>),
      supportFormats: json['support_formats'] as List<dynamic>,
      highFormat: json['high_format'],
      lastPlayTime: (json['lastPlayTime'] as num?)?.toInt(),
      lastPlayCid: (json['lastPlayCid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VideoPlayUrlToJson(VideoPlayUrl instance) =>
    <String, dynamic>{
      'from': instance.from,
      'result': instance.result,
      'message': instance.message,
      'quality': instance.quality,
      'format': instance.format,
      'timelength': instance.timeLength,
      'accept_format': instance.acceptFormat,
      'accept_description': instance.acceptDescription,
      'accept_quality': instance.acceptQuality,
      'video_codecid': instance.videoCodecId,
      'seek_param': instance.seekParam,
      'seek_type': instance.seekType,
      'support_formats': instance.supportFormats,
      'dash': instance.dash,
      'high_format': instance.highFormat,
      'lastPlayTime': instance.lastPlayTime,
      'lastPlayCid': instance.lastPlayCid,
    };

Dash _$DashFromJson(Map<String, dynamic> json) => Dash(
      duration: (json['duration'] as num).toInt(),
      minBufferTime: (json['minBufferTime'] as num).toDouble(),
      minBufferTimeAlt: (json['min_buffer_time'] as num).toDouble(),
      video: (json['video'] as List<dynamic>)
          .map((e) => VADItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      audio: (json['audio'] as List<dynamic>?)
          ?.map((e) => VADItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dolby: json['dolby'] == null
          ? null
          : Dolby.fromJson(json['dolby'] as Map<String, dynamic>),
      flac: json['flac'] == null
          ? null
          : Flac.fromJson(json['flac'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashToJson(Dash instance) => <String, dynamic>{
      'duration': instance.duration,
      'minBufferTime': instance.minBufferTime,
      'min_buffer_time': instance.minBufferTimeAlt,
      'video': instance.video,
      'audio': instance.audio,
      'dolby': instance.dolby,
      'flac': instance.flac,
    };

VADItem _$VADItemFromJson(Map<String, dynamic> json) => VADItem(
      id: (json['id'] as num).toInt(),
      baseUrl: json['baseUrl'] as String,
      base_url: json['base_url'] as String,
      backupUrl:
          (json['backupUrl'] as List<dynamic>).map((e) => e as String).toList(),
      backup_url: (json['backup_url'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bandwidth: (json['bandwidth'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      mime_type: json['mime_type'] as String,
      codecs: json['codecs'] as String,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      frameRate: json['frameRate'] as String?,
      frame_rate: json['frame_rate'] as String?,
      sar: json['sar'] as String?,
      startWithSap: (json['startWithSap'] as num?)?.toInt(),
      start_with_sap: (json['start_with_sap'] as num?)?.toInt(),
      segmentBase: json['SegmentBase'] == null
          ? null
          : SegmentBase.fromJson(json['SegmentBase'] as Map<String, dynamic>),
      segment_base: json['segment_base'] == null
          ? null
          : SegmentBase.fromJson(json['segment_base'] as Map<String, dynamic>),
      codecid: (json['codecid'] as num).toInt(),
    );

Map<String, dynamic> _$VADItemToJson(VADItem instance) => <String, dynamic>{
      'id': instance.id,
      'baseUrl': instance.baseUrl,
      'base_url': instance.base_url,
      'backupUrl': instance.backupUrl,
      'backup_url': instance.backup_url,
      'bandwidth': instance.bandwidth,
      'mimeType': instance.mimeType,
      'mime_type': instance.mime_type,
      'codecs': instance.codecs,
      'width': instance.width,
      'height': instance.height,
      'frameRate': instance.frameRate,
      'frame_rate': instance.frame_rate,
      'sar': instance.sar,
      'startWithSap': instance.startWithSap,
      'start_with_sap': instance.start_with_sap,
      'SegmentBase': instance.segmentBase,
      'segment_base': instance.segment_base,
      'codecid': instance.codecid,
    };

SegmentBase _$SegmentBaseFromJson(Map<String, dynamic> json) => SegmentBase(
      initialization: json['initialization'] as String?,
      indexRange: json['index_range'] as String?,
    );

Map<String, dynamic> _$SegmentBaseToJson(SegmentBase instance) =>
    <String, dynamic>{
      'initialization': instance.initialization,
      'index_range': instance.indexRange,
    };

Dolby _$DolbyFromJson(Map<String, dynamic> json) => Dolby(
      type: (json['type'] as num).toInt(),
      audio: (json['audio'] as List<dynamic>?)
          ?.map((e) => VADItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DolbyToJson(Dolby instance) => <String, dynamic>{
      'type': instance.type,
      'audio': instance.audio,
    };

Flac _$FlacFromJson(Map<String, dynamic> json) => Flac(
      display: json['display'] as bool,
      audio: (json['audio'] as List<dynamic>?)
          ?.map((e) => VADItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlacToJson(Flac instance) => <String, dynamic>{
      'display': instance.display,
      'audio': instance.audio,
    };
