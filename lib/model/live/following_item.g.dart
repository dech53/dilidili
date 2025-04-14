// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowingLiveItems _$FollowingLiveItemsFromJson(Map<String, dynamic> json) =>
    FollowingLiveItems(
      title: json['title'] as String?,
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalPage: (json['totalPage'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => FollowingLiveItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
      neverLivedCount: (json['never_lived_count'] as num?)?.toInt(),
      liveCount: (json['live_count'] as num?)?.toInt(),
      neverLivedFaces: json['never_lived_faces'] as List<dynamic>?,
    );

Map<String, dynamic> _$FollowingLiveItemsToJson(FollowingLiveItems instance) =>
    <String, dynamic>{
      'title': instance.title,
      'pageSize': instance.pageSize,
      'totalPage': instance.totalPage,
      'list': instance.list,
      'count': instance.count,
      'never_lived_count': instance.neverLivedCount,
      'live_count': instance.liveCount,
      'never_lived_faces': instance.neverLivedFaces,
    };

FollowingLiveItem _$FollowingLiveItemFromJson(Map<String, dynamic> json) =>
    FollowingLiveItem(
      roomid: (json['roomid'] as num?)?.toInt(),
      uid: (json['uid'] as num?)?.toInt(),
      uname: json['uname'] as String?,
      title: json['title'] as String?,
      face: json['face'] as String?,
      liveStatus: (json['live_status'] as num?)?.toInt(),
      recordNum: (json['record_num'] as num?)?.toInt(),
      recentRecordId: json['recent_record_id'] as String?,
      isAttention: (json['is_attention'] as num?)?.toInt(),
      clipnum: (json['clipnum'] as num?)?.toInt(),
      fansNum: (json['fans_num'] as num?)?.toInt(),
      areaName: json['area_name'] as String?,
      areaValue: json['area_value'] as String?,
      tags: json['tags'] as String?,
      recentRecordIdV2: json['recent_record_id_v2'] as String?,
      recordNumV2: (json['record_num_v2'] as num?)?.toInt(),
      recordLiveTime: (json['record_live_time'] as num?)?.toInt(),
      areaNameV2: json['area_name_v2'] as String?,
      roomNews: json['room_news'] as String?,
      listSwitch: json['switch'] as bool?,
      watchIcon: json['watch_icon'] as String?,
      textSmall: json['text_small'] as String?,
      roomCover: json['room_cover'] as String?,
      parentAreaId: (json['parent_area_id'] as num?)?.toInt(),
      areaId: (json['area_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FollowingLiveItemToJson(FollowingLiveItem instance) =>
    <String, dynamic>{
      'roomid': instance.roomid,
      'uid': instance.uid,
      'uname': instance.uname,
      'title': instance.title,
      'face': instance.face,
      'live_status': instance.liveStatus,
      'record_num': instance.recordNum,
      'recent_record_id': instance.recentRecordId,
      'is_attention': instance.isAttention,
      'clipnum': instance.clipnum,
      'fans_num': instance.fansNum,
      'area_name': instance.areaName,
      'area_value': instance.areaValue,
      'tags': instance.tags,
      'recent_record_id_v2': instance.recentRecordIdV2,
      'record_num_v2': instance.recordNumV2,
      'record_live_time': instance.recordLiveTime,
      'area_name_v2': instance.areaNameV2,
      'room_news': instance.roomNews,
      'switch': instance.listSwitch,
      'watch_icon': instance.watchIcon,
      'text_small': instance.textSmall,
      'room_cover': instance.roomCover,
      'parent_area_id': instance.parentAreaId,
      'area_id': instance.areaId,
    };
