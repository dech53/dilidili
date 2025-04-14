// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rcmd_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendLiveItems _$RecommendLiveItemsFromJson(Map<String, dynamic> json) =>
    RecommendLiveItems(
      recommendRoomList: (json['recommend_room_list'] as List<dynamic>?)
          ?.map((e) => RecommendLiveItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      topRoomId: (json['top_room_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecommendLiveItemsToJson(RecommendLiveItems instance) =>
    <String, dynamic>{
      'recommend_room_list': instance.recommendRoomList,
      'top_room_id': instance.topRoomId,
    };

RecommendLiveItem _$RecommendLiveItemFromJson(Map<String, dynamic> json) =>
    RecommendLiveItem(
      headBox: json['head_box'] == null
          ? null
          : HeadBox.fromJson(json['head_box'] as Map<String, dynamic>),
      areaV2Id: (json['area_v2_id'] as num?)?.toInt(),
      areaV2ParentId: (json['area_v2_parent_id'] as num?)?.toInt(),
      areaV2Name: json['area_v2_name'] as String?,
      areaV2ParentName: json['area_v2_parent_name'] as String?,
      broadcastType: (json['broadcast_type'] as num?)?.toInt(),
      cover: json['cover'] as String?,
      link: json['link'] as String?,
      online: (json['online'] as num?)?.toInt(),
      pendantInfo: json['pendant_Info'] == null
          ? null
          : PendantInfo.fromJson(json['pendant_Info'] as Map<String, dynamic>),
      roomid: (json['roomid'] as num?)?.toInt(),
      title: json['title'] as String?,
      uname: json['uname'] as String?,
      face: json['face'] as String?,
      verify: json['verify'] == null
          ? null
          : Verify.fromJson(json['verify'] as Map<String, dynamic>),
      uid: (json['uid'] as num?)?.toInt(),
      keyframe: json['keyframe'] as String?,
      isAutoPlay: (json['is_auto_play'] as num?)?.toInt(),
      headBoxType: (json['head_box_type'] as num?)?.toInt(),
      flag: (json['flag'] as num?)?.toInt(),
      sessionId: json['session_id'] as String?,
      groupId: (json['group_id'] as num?)?.toInt(),
      showCallback: json['show_callback'] as String?,
      clickCallback: json['click_callback'] as String?,
      specialId: (json['special_id'] as num?)?.toInt(),
      watchedShow: json['watched_show'] == null
          ? null
          : WatchedShow.fromJson(json['watched_show'] as Map<String, dynamic>),
      isNft: (json['is_nft'] as num?)?.toInt(),
      nftDmark: json['nft_dmark'] as String?,
      isAd: json['is_ad'] as bool?,
      adTransparentContent: json['ad_transparent_content'],
      showAdIcon: json['show_ad_icon'] as bool?,
      status: json['status'] as bool?,
      followers: (json['followers'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecommendLiveItemToJson(RecommendLiveItem instance) =>
    <String, dynamic>{
      'head_box': instance.headBox,
      'area_v2_id': instance.areaV2Id,
      'area_v2_parent_id': instance.areaV2ParentId,
      'area_v2_name': instance.areaV2Name,
      'area_v2_parent_name': instance.areaV2ParentName,
      'broadcast_type': instance.broadcastType,
      'cover': instance.cover,
      'link': instance.link,
      'online': instance.online,
      'pendant_Info': instance.pendantInfo,
      'roomid': instance.roomid,
      'title': instance.title,
      'uname': instance.uname,
      'face': instance.face,
      'verify': instance.verify,
      'uid': instance.uid,
      'keyframe': instance.keyframe,
      'is_auto_play': instance.isAutoPlay,
      'head_box_type': instance.headBoxType,
      'flag': instance.flag,
      'session_id': instance.sessionId,
      'group_id': instance.groupId,
      'show_callback': instance.showCallback,
      'click_callback': instance.clickCallback,
      'special_id': instance.specialId,
      'watched_show': instance.watchedShow,
      'is_nft': instance.isNft,
      'nft_dmark': instance.nftDmark,
      'is_ad': instance.isAd,
      'ad_transparent_content': instance.adTransparentContent,
      'show_ad_icon': instance.showAdIcon,
      'status': instance.status,
      'followers': instance.followers,
    };

HeadBox _$HeadBoxFromJson(Map<String, dynamic> json) => HeadBox(
      name: json['name'] as String?,
      value: json['value'] as String?,
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$HeadBoxToJson(HeadBox instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'desc': instance.desc,
    };

PendantInfo _$PendantInfoFromJson(Map<String, dynamic> json) => PendantInfo(
      the2: json['2'] == null
          ? null
          : The2.fromJson(json['2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PendantInfoToJson(PendantInfo instance) =>
    <String, dynamic>{
      '2': instance.the2,
    };

The2 _$The2FromJson(Map<String, dynamic> json) => The2(
      type: json['type'] as String?,
      name: json['name'] as String?,
      position: (json['position'] as num?)?.toInt(),
      text: json['text'] as String?,
      bgColor: json['bg_color'] as String?,
      bgPic: json['bg_pic'] as String?,
      pendantId: (json['pendant_id'] as num?)?.toInt(),
      priority: (json['priority'] as num?)?.toInt(),
      createdAt: (json['created_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$The2ToJson(The2 instance) => <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'position': instance.position,
      'text': instance.text,
      'bg_color': instance.bgColor,
      'bg_pic': instance.bgPic,
      'pendant_id': instance.pendantId,
      'priority': instance.priority,
      'created_at': instance.createdAt,
    };

Verify _$VerifyFromJson(Map<String, dynamic> json) => Verify(
      role: (json['role'] as num?)?.toInt(),
      desc: json['desc'] as String?,
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VerifyToJson(Verify instance) => <String, dynamic>{
      'role': instance.role,
      'desc': instance.desc,
      'type': instance.type,
    };

WatchedShow _$WatchedShowFromJson(Map<String, dynamic> json) => WatchedShow(
      watchedShowSwitch: json['switch'] as bool?,
      num: (json['num'] as num?)?.toInt(),
      textSmall: json['text_small'] as String?,
      textLarge: json['text_large'] as String?,
      icon: json['icon'] as String?,
      iconLocation: (json['icon_location'] as num?)?.toInt(),
      iconWeb: json['icon_web'] as String?,
    );

Map<String, dynamic> _$WatchedShowToJson(WatchedShow instance) =>
    <String, dynamic>{
      'switch': instance.watchedShowSwitch,
      'num': instance.num,
      'text_small': instance.textSmall,
      'text_large': instance.textLarge,
      'icon': instance.icon,
      'icon_location': instance.iconLocation,
      'icon_web': instance.iconWeb,
    };
