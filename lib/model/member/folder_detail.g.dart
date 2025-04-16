// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderDetail _$FolderDetailFromJson(Map<String, dynamic> json) => FolderDetail(
      id: (json['id'] as num?)?.toInt(),
      fid: (json['fid'] as num?)?.toInt(),
      mid: (json['mid'] as num?)?.toInt(),
      attr: (json['attr'] as num?)?.toInt(),
      title: json['title'] as String?,
      cover: json['cover'] as String?,
      upper: json['upper'] == null
          ? null
          : Upper.fromJson(json['upper'] as Map<String, dynamic>),
      coverType: (json['cover_type'] as num?)?.toInt(),
      cntInfo: json['cnt_info'] == null
          ? null
          : CntInfo.fromJson(json['cnt_info'] as Map<String, dynamic>),
      type: (json['type'] as num?)?.toInt(),
      intro: json['intro'] as String?,
      ctime: (json['ctime'] as num?)?.toInt(),
      mtime: (json['mtime'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      favState: (json['fav_state'] as num?)?.toInt(),
      likeState: (json['like_state'] as num?)?.toInt(),
      mediaCount: (json['media_count'] as num?)?.toInt(),
      isTop: json['is_top'] as bool?,
    );

Map<String, dynamic> _$FolderDetailToJson(FolderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fid': instance.fid,
      'mid': instance.mid,
      'attr': instance.attr,
      'title': instance.title,
      'cover': instance.cover,
      'upper': instance.upper,
      'cover_type': instance.coverType,
      'cnt_info': instance.cntInfo,
      'type': instance.type,
      'intro': instance.intro,
      'ctime': instance.ctime,
      'mtime': instance.mtime,
      'state': instance.state,
      'fav_state': instance.favState,
      'like_state': instance.likeState,
      'media_count': instance.mediaCount,
      'is_top': instance.isTop,
    };

CntInfo _$CntInfoFromJson(Map<String, dynamic> json) => CntInfo(
      collect: (json['collect'] as num?)?.toInt(),
      play: (json['play'] as num?)?.toInt(),
      thumbUp: (json['thumb_up'] as num?)?.toInt(),
      share: (json['share'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CntInfoToJson(CntInfo instance) => <String, dynamic>{
      'collect': instance.collect,
      'play': instance.play,
      'thumb_up': instance.thumbUp,
      'share': instance.share,
    };

Upper _$UpperFromJson(Map<String, dynamic> json) => Upper(
      mid: (json['mid'] as num?)?.toInt(),
      name: json['name'] as String?,
      face: json['face'] as String?,
      followed: json['followed'] as bool?,
      vipType: (json['vip_type'] as num?)?.toInt(),
      vipStatue: (json['vip_statue'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpperToJson(Upper instance) => <String, dynamic>{
      'mid': instance.mid,
      'name': instance.name,
      'face': instance.face,
      'followed': instance.followed,
      'vip_type': instance.vipType,
      'vip_statue': instance.vipStatue,
    };
