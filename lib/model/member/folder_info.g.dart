// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderInfo _$FolderInfoFromJson(Map<String, dynamic> json) => FolderInfo(
      count: (json['count'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => FolderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      season: json['season'],
    );

Map<String, dynamic> _$FolderInfoToJson(FolderInfo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'list': instance.list,
      'season': instance.season,
    };

FolderItem _$FolderItemFromJson(Map<String, dynamic> json) => FolderItem(
      id: (json['id'] as num?)?.toInt(),
      fid: (json['fid'] as num?)?.toInt(),
      mid: (json['mid'] as num?)?.toInt(),
      attr: (json['attr'] as num?)?.toInt(),
      title: json['title'] as String?,
      favState: (json['fav_state'] as num?)?.toInt(),
      mediaCount: (json['media_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FolderItemToJson(FolderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fid': instance.fid,
      'mid': instance.mid,
      'attr': instance.attr,
      'title': instance.title,
      'fav_state': instance.favState,
      'media_count': instance.mediaCount,
    };
