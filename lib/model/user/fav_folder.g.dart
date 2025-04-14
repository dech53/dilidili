// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavFolderData _$FavFolderDataFromJson(Map<String, dynamic> json) =>
    FavFolderData(
      count: (json['count'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => ListElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      season: json['season'],
    );

Map<String, dynamic> _$FavFolderDataToJson(FavFolderData instance) =>
    <String, dynamic>{
      'count': instance.count,
      'list': instance.list,
      'season': instance.season,
    };

ListElement _$ListElementFromJson(Map<String, dynamic> json) => ListElement(
      id: (json['id'] as num?)?.toInt(),
      fid: (json['fid'] as num?)?.toInt(),
      mid: (json['mid'] as num?)?.toInt(),
      attr: (json['attr'] as num?)?.toInt(),
      title: json['title'] as String?,
      favState: (json['fav_state'] as num?)?.toInt(),
      mediaCount: (json['media_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ListElementToJson(ListElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fid': instance.fid,
      'mid': instance.mid,
      'attr': instance.attr,
      'title': instance.title,
      'fav_state': instance.favState,
      'media_count': instance.mediaCount,
    };
