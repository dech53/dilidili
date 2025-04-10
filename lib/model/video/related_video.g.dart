// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedVideoItem _$RelatedVideoItemFromJson(Map<String, dynamic> json) =>
    RelatedVideoItem(
      aid: (json['aid'] as num?)?.toInt(),
      videos: (json['videos'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      tname: json['tname'] as String?,
      copyright: (json['copyright'] as num?)?.toInt(),
      pic: json['pic'] as String?,
      title: json['title'] as String?,
      pubdate: (json['pubdate'] as num?)?.toInt(),
      ctime: (json['ctime'] as num?)?.toInt(),
      desc: json['desc'] as String?,
      state: (json['state'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      rights: (json['rights'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      stat: (json['stat'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      relatedVideoItemDynamic: json['dynamic'] as String?,
      cid: (json['cid'] as num?)?.toInt(),
      dimension: json['dimension'] == null
          ? null
          : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
      seasonId: (json['season_id'] as num?)?.toInt(),
      shortLinkV2: json['short_link_v2'] as String?,
      firstFrame: json['first_frame'] as String?,
      pubLocation: json['pub_location'] as String?,
      cover43: json['cover43'] as String?,
      tidv2: (json['tidv2'] as num?)?.toInt(),
      tnamev2: json['tnamev2'] as String?,
      pidV2: (json['pid_v2'] as num?)?.toInt(),
      pidNameV2: json['pid_name_v2'] as String?,
      bvid: json['bvid'] as String?,
      seasonType: (json['season_type'] as num?)?.toInt(),
      isOgv: json['is_ogv'] as bool?,
      ogvInfo: json['ogv_info'],
      rcmdReason: json['rcmd_reason'] as String?,
      enableVt: (json['enable_vt'] as num?)?.toInt(),
      aiRcmd: json['ai_rcmd'] == null
          ? null
          : AiRcmd.fromJson(json['ai_rcmd'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RelatedVideoItemToJson(RelatedVideoItem instance) =>
    <String, dynamic>{
      'aid': instance.aid,
      'videos': instance.videos,
      'tid': instance.tid,
      'tname': instance.tname,
      'copyright': instance.copyright,
      'pic': instance.pic,
      'title': instance.title,
      'pubdate': instance.pubdate,
      'ctime': instance.ctime,
      'desc': instance.desc,
      'state': instance.state,
      'duration': instance.duration,
      'rights': instance.rights,
      'owner': instance.owner,
      'stat': instance.stat,
      'dynamic': instance.relatedVideoItemDynamic,
      'cid': instance.cid,
      'dimension': instance.dimension,
      'season_id': instance.seasonId,
      'short_link_v2': instance.shortLinkV2,
      'first_frame': instance.firstFrame,
      'pub_location': instance.pubLocation,
      'cover43': instance.cover43,
      'tidv2': instance.tidv2,
      'tnamev2': instance.tnamev2,
      'pid_v2': instance.pidV2,
      'pid_name_v2': instance.pidNameV2,
      'bvid': instance.bvid,
      'season_type': instance.seasonType,
      'is_ogv': instance.isOgv,
      'ogv_info': instance.ogvInfo,
      'rcmd_reason': instance.rcmdReason,
      'enable_vt': instance.enableVt,
      'ai_rcmd': instance.aiRcmd,
    };

AiRcmd _$AiRcmdFromJson(Map<String, dynamic> json) => AiRcmd(
      id: (json['id'] as num?)?.toInt(),
      goto: json['goto'] as String?,
      trackid: json['trackid'] as String?,
      uniqId: json['uniq_id'] as String?,
    );

Map<String, dynamic> _$AiRcmdToJson(AiRcmd instance) => <String, dynamic>{
      'id': instance.id,
      'goto': instance.goto,
      'trackid': instance.trackid,
      'uniq_id': instance.uniqId,
    };

Dimension _$DimensionFromJson(Map<String, dynamic> json) => Dimension(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      rotate: (json['rotate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DimensionToJson(Dimension instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'rotate': instance.rotate,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      mid: (json['mid'] as num?)?.toInt(),
      name: json['name'] as String?,
      face: json['face'] as String?,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'mid': instance.mid,
      'name': instance.name,
      'face': instance.face,
    };
