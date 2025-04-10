// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_basic_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoDetailData _$VideoDetailDataFromJson(Map<String, dynamic> json) =>
    VideoDetailData(
      bvid: json['bvid'] as String?,
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
      descV2: (json['desc_v2'] as List<dynamic>?)
          ?.map((e) => DescV2.fromJson(e as Map<String, dynamic>))
          .toList(),
      state: (json['state'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      rights: (json['rights'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      stat: json['stat'] == null
          ? null
          : Stat.fromJson(json['stat'] as Map<String, dynamic>),
      argueInfo: json['argue_info'] == null
          ? null
          : ArgueInfo.fromJson(json['argue_info'] as Map<String, dynamic>),
      videoDynamic: json['video_dynamic'] as String?,
      cid: (json['cid'] as num?)?.toInt(),
      dimension: json['dimension'] == null
          ? null
          : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
      premiere: json['premiere'],
      teenageMode: (json['teenage_mode'] as num?)?.toInt(),
      isChargeableSeason: json['is_chargeable_season'] as bool?,
      isStory: json['is_story'] as bool?,
      noCache: json['no_cache'] as bool?,
      pages: (json['pages'] as List<dynamic>?)
          ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtitle: json['subtitle'] == null
          ? null
          : Subtitle.fromJson(json['subtitle'] as Map<String, dynamic>),
      ugcSeason: json['ugc_season'] == null
          ? null
          : UgcSeason.fromJson(json['ugc_season'] as Map<String, dynamic>),
      isSeasonDisplay: json['is_season_display'] as bool?,
      userGarb: json['user_garb'] == null
          ? null
          : UserGarb.fromJson(json['user_garb'] as Map<String, dynamic>),
      honorReply: json['honor_reply'] == null
          ? null
          : HonorReply.fromJson(json['honor_reply'] as Map<String, dynamic>),
      likeIcon: json['like_icon'] as String?,
      needJumpBv: json['need_jump_bv'] as bool?,
      epId: json['ep_id'] as String?,
      staff: (json['staff'] as List<dynamic>?)
          ?.map((e) => Staff.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideoDetailDataToJson(VideoDetailData instance) =>
    <String, dynamic>{
      'bvid': instance.bvid,
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
      'desc_v2': instance.descV2,
      'state': instance.state,
      'duration': instance.duration,
      'rights': instance.rights,
      'argue_info': instance.argueInfo,
      'owner': instance.owner,
      'stat': instance.stat,
      'video_dynamic': instance.videoDynamic,
      'cid': instance.cid,
      'dimension': instance.dimension,
      'premiere': instance.premiere,
      'teenage_mode': instance.teenageMode,
      'is_chargeable_season': instance.isChargeableSeason,
      'is_story': instance.isStory,
      'no_cache': instance.noCache,
      'pages': instance.pages,
      'subtitle': instance.subtitle,
      'ugc_season': instance.ugcSeason,
      'is_season_display': instance.isSeasonDisplay,
      'user_garb': instance.userGarb,
      'honor_reply': instance.honorReply,
      'like_icon': instance.likeIcon,
      'need_jump_bv': instance.needJumpBv,
      'ep_id': instance.epId,
      'staff': instance.staff,
    };

DescV2 _$DescV2FromJson(Map<String, dynamic> json) => DescV2(
      rawText: json['raw_text'] as String?,
      type: (json['type'] as num?)?.toInt(),
      bizId: (json['biz_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DescV2ToJson(DescV2 instance) => <String, dynamic>{
      'raw_text': instance.rawText,
      'type': instance.type,
      'biz_id': instance.bizId,
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

Part _$PartFromJson(Map<String, dynamic> json) => Part(
      cid: (json['cid'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      from: json['from'] as String?,
      pagePart: json['page_part'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      vid: json['vid'] as String?,
      weblink: json['weblink'] as String?,
      dimension: json['dimension'] == null
          ? null
          : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
      firstFrame: json['first_frame'] as String?,
      cover: json['cover'] as String?,
    );

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
      'cid': instance.cid,
      'page': instance.page,
      'from': instance.from,
      'page_part': instance.pagePart,
      'duration': instance.duration,
      'vid': instance.vid,
      'weblink': instance.weblink,
      'dimension': instance.dimension,
      'first_frame': instance.firstFrame,
      'cover': instance.cover,
    };

Subtitle _$SubtitleFromJson(Map<String, dynamic> json) => Subtitle(
      allowSubmit: json['allow_submit'] as bool?,
      list: json['list'] as List<dynamic>?,
    );

Map<String, dynamic> _$SubtitleToJson(Subtitle instance) => <String, dynamic>{
      'allow_submit': instance.allowSubmit,
      'list': instance.list,
    };

UgcSeason _$UgcSeasonFromJson(Map<String, dynamic> json) => UgcSeason(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      cover: json['cover'] as String?,
      mid: (json['mid'] as num?)?.toInt(),
      intro: json['intro'] as String?,
      signState: (json['sign_state'] as num?)?.toInt(),
      attribute: (json['attribute'] as num?)?.toInt(),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => SectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      stat: json['stat'] == null
          ? null
          : Stat.fromJson(json['stat'] as Map<String, dynamic>),
      epCount: (json['ep_count'] as num?)?.toInt(),
      seasonType: (json['season_type'] as num?)?.toInt(),
      isPaySeason: json['is_pay_season'] as bool?,
    );

Map<String, dynamic> _$UgcSeasonToJson(UgcSeason instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover': instance.cover,
      'mid': instance.mid,
      'intro': instance.intro,
      'sign_state': instance.signState,
      'attribute': instance.attribute,
      'sections': instance.sections,
      'stat': instance.stat,
      'ep_count': instance.epCount,
      'season_type': instance.seasonType,
      'is_pay_season': instance.isPaySeason,
    };

UserGarb _$UserGarbFromJson(Map<String, dynamic> json) => UserGarb(
      urlImageAniCut: json['url_image_ani_cut'] as String?,
    );

Map<String, dynamic> _$UserGarbToJson(UserGarb instance) => <String, dynamic>{
      'url_image_ani_cut': instance.urlImageAniCut,
    };

HonorReply _$HonorReplyFromJson(Map<String, dynamic> json) => HonorReply(
      honor: (json['honor'] as List<dynamic>?)
          ?.map((e) => Honor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HonorReplyToJson(HonorReply instance) =>
    <String, dynamic>{
      'honor': instance.honor,
    };

Staff _$StaffFromJson(Map<String, dynamic> json) => Staff(
      mid: (json['mid'] as num?)?.toInt(),
      title: json['title'] as String?,
      name: json['name'] as String?,
      face: json['face'] as String?,
      vip: json['vip'] == null
          ? null
          : Vip.fromJson(json['vip'] as Map<String, dynamic>),
    )..status = (json['status'] as num?)?.toInt();

Map<String, dynamic> _$StaffToJson(Staff instance) => <String, dynamic>{
      'mid': instance.mid,
      'title': instance.title,
      'name': instance.name,
      'face': instance.face,
      'status': instance.status,
      'vip': instance.vip,
    };

SectionItem _$SectionItemFromJson(Map<String, dynamic> json) => SectionItem(
      seasonId: (json['season_id'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      type: (json['type'] as num?)?.toInt(),
      episodes: (json['episodes'] as List<dynamic>?)
          ?.map((e) => EpisodeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SectionItemToJson(SectionItem instance) =>
    <String, dynamic>{
      'season_id': instance.seasonId,
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'episodes': instance.episodes,
    };

Honor _$HonorFromJson(Map<String, dynamic> json) => Honor(
      aid: (json['aid'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
      desc: json['desc'] as String?,
      weeklyRecommendNum: (json['weekly_recommend_num'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HonorToJson(Honor instance) => <String, dynamic>{
      'aid': instance.aid,
      'type': instance.type,
      'desc': instance.desc,
      'weekly_recommend_num': instance.weeklyRecommendNum,
    };

Vip _$VipFromJson(Map<String, dynamic> json) => Vip(
      type: (json['type'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VipToJson(Vip instance) => <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
    };

EpisodeItem _$EpisodeItemFromJson(Map<String, dynamic> json) => EpisodeItem(
      seasonId: (json['season_id'] as num?)?.toInt(),
      sectionId: (json['section_id'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      aid: (json['aid'] as num?)?.toInt(),
      cid: (json['cid'] as num?)?.toInt(),
      title: json['title'] as String?,
      attribute: (json['attribute'] as num?)?.toInt(),
      page: json['page'] == null
          ? null
          : Part.fromJson(json['page'] as Map<String, dynamic>),
      bvid: json['bvid'] as String?,
      cover: json['cover'] as String?,
    );

Map<String, dynamic> _$EpisodeItemToJson(EpisodeItem instance) =>
    <String, dynamic>{
      'season_id': instance.seasonId,
      'section_id': instance.sectionId,
      'id': instance.id,
      'aid': instance.aid,
      'cid': instance.cid,
      'title': instance.title,
      'attribute': instance.attribute,
      'page': instance.page,
      'bvid': instance.bvid,
      'cover': instance.cover,
    };

ArgueInfo _$ArgueInfoFromJson(Map<String, dynamic> json) => ArgueInfo(
      argue_link: json['argue_link'] as String?,
      argue_msg: json['argue_msg'] as String?,
      argue_type: (json['argue_type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ArgueInfoToJson(ArgueInfo instance) => <String, dynamic>{
      'argue_link': instance.argue_link,
      'argue_msg': instance.argue_msg,
      'argue_type': instance.argue_type,
    };
