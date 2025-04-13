// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotVideoItemList _$HotVideoItemListFromJson(Map<String, dynamic> json) =>
    HotVideoItemList(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => HotVideoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      noMore: json['no_more'] as bool?,
    );

Map<String, dynamic> _$HotVideoItemListToJson(HotVideoItemList instance) =>
    <String, dynamic>{
      'list': instance.list,
      'no_more': instance.noMore,
    };

HotVideoItem _$HotVideoItemFromJson(Map<String, dynamic> json) => HotVideoItem(
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
      missionId: (json['mission_id'] as num?)?.toInt(),
      rights: (json['rights'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      stat: json['stat'] == null
          ? null
          : Stat.fromJson(json['stat'] as Map<String, dynamic>),
      listDynamic: json['dynamic'] as String?,
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
      enableVt: (json['enable_vt'] as num?)?.toInt(),
      aiRcmd: json['ai_rcmd'],
      rcmdReason: json['rcmd_reason'] == null
          ? null
          : RcmdReason.fromJson(json['rcmd_reason'] as Map<String, dynamic>),
      upFromV2: (json['up_from_v2'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HotVideoItemToJson(HotVideoItem instance) =>
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
      'mission_id': instance.missionId,
      'rights': instance.rights,
      'owner': instance.owner,
      'stat': instance.stat,
      'dynamic': instance.listDynamic,
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
      'enable_vt': instance.enableVt,
      'ai_rcmd': instance.aiRcmd,
      'rcmd_reason': instance.rcmdReason,
      'up_from_v2': instance.upFromV2,
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

RcmdReason _$RcmdReasonFromJson(Map<String, dynamic> json) => RcmdReason(
      content: json['content'] as String?,
      cornerMark: (json['corner_mark'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RcmdReasonToJson(RcmdReason instance) =>
    <String, dynamic>{
      'content': instance.content,
      'corner_mark': instance.cornerMark,
    };

Stat _$StatFromJson(Map<String, dynamic> json) => Stat(
      aid: (json['aid'] as num?)?.toInt(),
      view: (json['view'] as num?)?.toInt(),
      danmaku: (json['danmaku'] as num?)?.toInt(),
      reply: (json['reply'] as num?)?.toInt(),
      favorite: (json['favorite'] as num?)?.toInt(),
      coin: (json['coin'] as num?)?.toInt(),
      share: (json['share'] as num?)?.toInt(),
      nowRank: (json['now_rank'] as num?)?.toInt(),
      hisRank: (json['all_rank'] as num?)?.toInt(),
      like: (json['like'] as num?)?.toInt(),
      dislike: (json['dislike'] as num?)?.toInt(),
      vt: (json['vt'] as num?)?.toInt(),
      vv: (json['vv'] as num?)?.toInt(),
      favG: (json['fav_g'] as num?)?.toInt(),
      likeG: (json['like_g'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StatToJson(Stat instance) => <String, dynamic>{
      'aid': instance.aid,
      'view': instance.view,
      'danmaku': instance.danmaku,
      'reply': instance.reply,
      'favorite': instance.favorite,
      'coin': instance.coin,
      'share': instance.share,
      'now_rank': instance.nowRank,
      'all_rank': instance.hisRank,
      'like': instance.like,
      'dislike': instance.dislike,
      'vt': instance.vt,
      'vv': instance.vv,
      'fav_g': instance.favG,
      'like_g': instance.likeG,
    };
