// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rcmd_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RcmdVideo _$RcmdVideoFromJson(Map<String, dynamic> json) => RcmdVideo(
      item: (json['item'] as List<dynamic>)
          .map((e) => RcmdVideoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      business_card: json['business_card'],
      floor_info: json['floor_info'],
      user_feature: json['user_feature'],
      preload_expose_pct: (json['preload_expose_pct'] as num).toInt(),
      preload_floor_expose_pct:
          (json['preload_floor_expose_pct'] as num).toInt(),
      mid: (json['mid'] as num).toInt(),
    );

Map<String, dynamic> _$RcmdVideoToJson(RcmdVideo instance) => <String, dynamic>{
      'item': instance.item,
      'business_card': instance.business_card,
      'floor_info': instance.floor_info,
      'user_feature': instance.user_feature,
      'preload_expose_pct': instance.preload_expose_pct,
      'preload_floor_expose_pct': instance.preload_floor_expose_pct,
      'mid': instance.mid,
    };

RcmdVideoItem _$RcmdVideoItemFromJson(Map<String, dynamic> json) =>
    RcmdVideoItem(
      id: (json['id'] as num).toInt(),
      bvid: json['bvid'] as String,
      cid: (json['cid'] as num).toInt(),
      goto: json['goto'] as String,
      uri: json['uri'] as String,
      pic: json['pic'] as String,
      pic_4_3: json['pic_4_3'] as String,
      title: json['title'] as String,
      duration: (json['duration'] as num).toInt(),
      pubdate: (json['pubdate'] as num).toInt(),
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      stat: Stat.fromJson(json['stat'] as Map<String, dynamic>),
      av_feature: json['av_feature'],
      is_followed: (json['is_followed'] as num).toInt(),
      rcmd_reason: json['rcmd_reason'] == null
          ? null
          : RcmdReason.fromJson(json['rcmd_reason'] as Map<String, dynamic>),
      show_info: (json['show_info'] as num).toInt(),
      track_id: json['track_id'] as String,
      pos: (json['pos'] as num).toInt(),
      room_info: json['room_info'],
      ogv_info: json['ogv_info'],
      business_info: json['business_info'],
      is_stock: (json['is_stock'] as num).toInt(),
      enable_vt: (json['enable_vt'] as num).toInt(),
      vt_display: json['vt_display'] as String,
      dislike_switch: (json['dislike_switch'] as num).toInt(),
      dislike_switch_pc: (json['dislike_switch_pc'] as num).toInt(),
    );

Map<String, dynamic> _$RcmdVideoItemToJson(RcmdVideoItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bvid': instance.bvid,
      'cid': instance.cid,
      'goto': instance.goto,
      'uri': instance.uri,
      'pic': instance.pic,
      'pic_4_3': instance.pic_4_3,
      'title': instance.title,
      'duration': instance.duration,
      'pubdate': instance.pubdate,
      'owner': instance.owner,
      'stat': instance.stat,
      'av_feature': instance.av_feature,
      'is_followed': instance.is_followed,
      'rcmd_reason': instance.rcmd_reason,
      'show_info': instance.show_info,
      'track_id': instance.track_id,
      'pos': instance.pos,
      'room_info': instance.room_info,
      'ogv_info': instance.ogv_info,
      'business_info': instance.business_info,
      'is_stock': instance.is_stock,
      'enable_vt': instance.enable_vt,
      'vt_display': instance.vt_display,
      'dislike_switch': instance.dislike_switch,
      'dislike_switch_pc': instance.dislike_switch_pc,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      mid: (json['mid'] as num).toInt(),
      name: json['name'] as String,
      face: json['face'] as String,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'mid': instance.mid,
      'name': instance.name,
      'face': instance.face,
    };

RcmdReason _$RcmdReasonFromJson(Map<String, dynamic> json) => RcmdReason(
      reasonType: (json['reasonType'] as num?)?.toInt(),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$RcmdReasonToJson(RcmdReason instance) =>
    <String, dynamic>{
      'reasonType': instance.reasonType,
      'content': instance.content,
    };

Stat _$StatFromJson(Map<String, dynamic> json) => Stat(
      view: (json['view'] as num).toInt(),
      like: (json['like'] as num).toInt(),
      danmaku: (json['danmaku'] as num).toInt(),
      vt: (json['vt'] as num).toInt(),
    );

Map<String, dynamic> _$StatToJson(Stat instance) => <String, dynamic>{
      'view': instance.view,
      'like': instance.like,
      'danmaku': instance.danmaku,
      'vt': instance.vt,
    };
