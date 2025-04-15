// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberInfo _$MemberInfoFromJson(Map<String, dynamic> json) => MemberInfo(
      mid: (json['mid'] as num?)?.toInt(),
      name: json['name'] as String?,
      sex: json['sex'] as String?,
      face: json['face'] as String?,
      faceNft: (json['face_nft'] as num?)?.toInt(),
      faceNftType: (json['face_nft_type'] as num?)?.toInt(),
      sign: json['sign'] as String?,
      rank: (json['rank'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      jointime: (json['jointime'] as num?)?.toInt(),
      moral: (json['moral'] as num?)?.toInt(),
      silence: (json['silence'] as num?)?.toInt(),
      coins: (json['coins'] as num?)?.toDouble(),
      fansBadge: json['fans_badge'] as bool?,
      fansMedal: json['fans_medal'] == null
          ? null
          : FansMedal.fromJson(json['fans_medal'] as Map<String, dynamic>),
      official: json['official'] == null
          ? null
          : Official.fromJson(json['official'] as Map<String, dynamic>),
      vip: json['vip'] == null
          ? null
          : Vip.fromJson(json['vip'] as Map<String, dynamic>),
      pendant: json['pendant'] == null
          ? null
          : Pendant.fromJson(json['pendant'] as Map<String, dynamic>),
      nameplate: json['nameplate'] == null
          ? null
          : Nameplate.fromJson(json['nameplate'] as Map<String, dynamic>),
      userHonourInfo: json['user_honour_info'] == null
          ? null
          : UserHonourInfo.fromJson(
              json['user_honour_info'] as Map<String, dynamic>),
      isFollowed: json['is_followed'] as bool?,
      topPhoto: json['top_photo'] as String?,
      sysNotice: json['sys_notice'] == null
          ? null
          : SysNotice.fromJson(json['sys_notice'] as Map<String, dynamic>),
      liveRoom: json['live_room'] == null
          ? null
          : LiveRoom.fromJson(json['live_room'] as Map<String, dynamic>),
      birthday: json['birthday'] as String?,
      school: json['school'] == null
          ? null
          : School.fromJson(json['school'] as Map<String, dynamic>),
      profession: json['profession'] == null
          ? null
          : Profession.fromJson(json['profession'] as Map<String, dynamic>),
      tags: json['tags'],
      series: json['series'] == null
          ? null
          : Series.fromJson(json['series'] as Map<String, dynamic>),
      isSeniorMember: (json['is_senior_member'] as num?)?.toInt(),
      mcnInfo: json['mcn_info'],
      gaiaResType: (json['gaia_res_type'] as num?)?.toInt(),
      gaiaData: json['gaia_data'],
      isRisk: json['is_risk'] as bool?,
      elec: json['elec'] == null
          ? null
          : Elec.fromJson(json['elec'] as Map<String, dynamic>),
      contract: json['contract'] == null
          ? null
          : Contract.fromJson(json['contract'] as Map<String, dynamic>),
      certificateShow: json['certificate_show'] as bool?,
      nameRender: json['name_render'],
      topPhotoV2: json['top_photo_v2'] == null
          ? null
          : TopPhotoV2.fromJson(json['top_photo_v2'] as Map<String, dynamic>),
      theme: json['theme'],
      attestation: json['attestation'] == null
          ? null
          : Attestation.fromJson(json['attestation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberInfoToJson(MemberInfo instance) =>
    <String, dynamic>{
      'mid': instance.mid,
      'name': instance.name,
      'sex': instance.sex,
      'face': instance.face,
      'face_nft': instance.faceNft,
      'face_nft_type': instance.faceNftType,
      'sign': instance.sign,
      'rank': instance.rank,
      'level': instance.level,
      'jointime': instance.jointime,
      'moral': instance.moral,
      'silence': instance.silence,
      'coins': instance.coins,
      'fans_badge': instance.fansBadge,
      'fans_medal': instance.fansMedal,
      'official': instance.official,
      'vip': instance.vip,
      'pendant': instance.pendant,
      'nameplate': instance.nameplate,
      'user_honour_info': instance.userHonourInfo,
      'is_followed': instance.isFollowed,
      'top_photo': instance.topPhoto,
      'sys_notice': instance.sysNotice,
      'live_room': instance.liveRoom,
      'birthday': instance.birthday,
      'school': instance.school,
      'profession': instance.profession,
      'tags': instance.tags,
      'series': instance.series,
      'is_senior_member': instance.isSeniorMember,
      'mcn_info': instance.mcnInfo,
      'gaia_res_type': instance.gaiaResType,
      'gaia_data': instance.gaiaData,
      'is_risk': instance.isRisk,
      'elec': instance.elec,
      'contract': instance.contract,
      'certificate_show': instance.certificateShow,
      'name_render': instance.nameRender,
      'top_photo_v2': instance.topPhotoV2,
      'theme': instance.theme,
      'attestation': instance.attestation,
    };

Attestation _$AttestationFromJson(Map<String, dynamic> json) => Attestation(
      type: (json['type'] as num?)?.toInt(),
      commonInfo: json['common_info'] == null
          ? null
          : CommonInfo.fromJson(json['common_info'] as Map<String, dynamic>),
      spliceInfo: json['splice_info'] == null
          ? null
          : SpliceInfo.fromJson(json['splice_info'] as Map<String, dynamic>),
      icon: json['icon'] as String?,
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$AttestationToJson(Attestation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'common_info': instance.commonInfo,
      'splice_info': instance.spliceInfo,
      'icon': instance.icon,
      'desc': instance.desc,
    };

CommonInfo _$CommonInfoFromJson(Map<String, dynamic> json) => CommonInfo(
      title: json['title'] as String?,
      prefix: json['prefix'] as String?,
      prefixTitle: json['prefix_title'] as String?,
    );

Map<String, dynamic> _$CommonInfoToJson(CommonInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'prefix': instance.prefix,
      'prefix_title': instance.prefixTitle,
    };

SpliceInfo _$SpliceInfoFromJson(Map<String, dynamic> json) => SpliceInfo(
      title: json['title'] as String?,
    );

Map<String, dynamic> _$SpliceInfoToJson(SpliceInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      isDisplay: json['is_display'] as bool?,
      isFollowDisplay: json['is_follow_display'] as bool?,
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'is_display': instance.isDisplay,
      'is_follow_display': instance.isFollowDisplay,
    };

Elec _$ElecFromJson(Map<String, dynamic> json) => Elec(
      showInfo: json['show_info'] == null
          ? null
          : ShowInfo.fromJson(json['show_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ElecToJson(Elec instance) => <String, dynamic>{
      'show_info': instance.showInfo,
    };

ShowInfo _$ShowInfoFromJson(Map<String, dynamic> json) => ShowInfo(
      show: json['show'] as bool?,
      state: (json['state'] as num?)?.toInt(),
      title: json['title'] as String?,
      icon: json['icon'] as String?,
      jumpUrl: json['jump_url'] as String?,
    );

Map<String, dynamic> _$ShowInfoToJson(ShowInfo instance) => <String, dynamic>{
      'show': instance.show,
      'state': instance.state,
      'title': instance.title,
      'icon': instance.icon,
      'jump_url': instance.jumpUrl,
    };

FansMedal _$FansMedalFromJson(Map<String, dynamic> json) => FansMedal(
      show: json['show'] as bool?,
      wear: json['wear'] as bool?,
      medal: json['medal'] == null
          ? null
          : Medal.fromJson(json['medal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FansMedalToJson(FansMedal instance) => <String, dynamic>{
      'show': instance.show,
      'wear': instance.wear,
      'medal': instance.medal,
    };

Medal _$MedalFromJson(Map<String, dynamic> json) => Medal(
      uid: (json['uid'] as num?)?.toInt(),
      targetId: (json['target_id'] as num?)?.toInt(),
      medalId: (json['medal_id'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      medalName: json['medal_name'] as String?,
      medalColor: (json['medal_color'] as num?)?.toInt(),
      intimacy: (json['intimacy'] as num?)?.toInt(),
      nextIntimacy: (json['next_intimacy'] as num?)?.toInt(),
      dayLimit: (json['day_limit'] as num?)?.toInt(),
      medalColorStart: (json['medal_color_start'] as num?)?.toInt(),
      medalColorEnd: (json['medal_color_end'] as num?)?.toInt(),
      medalColorBorder: (json['medal_color_border'] as num?)?.toInt(),
      isLighted: (json['is_lighted'] as num?)?.toInt(),
      lightStatus: (json['light_status'] as num?)?.toInt(),
      wearingStatus: (json['wearing_status'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MedalToJson(Medal instance) => <String, dynamic>{
      'uid': instance.uid,
      'target_id': instance.targetId,
      'medal_id': instance.medalId,
      'level': instance.level,
      'medal_name': instance.medalName,
      'medal_color': instance.medalColor,
      'intimacy': instance.intimacy,
      'next_intimacy': instance.nextIntimacy,
      'day_limit': instance.dayLimit,
      'medal_color_start': instance.medalColorStart,
      'medal_color_end': instance.medalColorEnd,
      'medal_color_border': instance.medalColorBorder,
      'is_lighted': instance.isLighted,
      'light_status': instance.lightStatus,
      'wearing_status': instance.wearingStatus,
      'score': instance.score,
    };

LiveRoom _$LiveRoomFromJson(Map<String, dynamic> json) => LiveRoom(
      roomStatus: (json['roomStatus'] as num?)?.toInt(),
      liveStatus: (json['liveStatus'] as num?)?.toInt(),
      url: json['url'] as String?,
      title: json['title'] as String?,
      cover: json['cover'] as String?,
      roomid: (json['roomid'] as num?)?.toInt(),
      roundStatus: (json['roundStatus'] as num?)?.toInt(),
      broadcastType: (json['broadcast_type'] as num?)?.toInt(),
      watchedShow: json['watched_show'] == null
          ? null
          : WatchedShow.fromJson(json['watched_show'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LiveRoomToJson(LiveRoom instance) => <String, dynamic>{
      'roomStatus': instance.roomStatus,
      'liveStatus': instance.liveStatus,
      'url': instance.url,
      'title': instance.title,
      'cover': instance.cover,
      'roomid': instance.roomid,
      'roundStatus': instance.roundStatus,
      'broadcast_type': instance.broadcastType,
      'watched_show': instance.watchedShow,
    };

WatchedShow _$WatchedShowFromJson(Map<String, dynamic> json) => WatchedShow(
      watchedShowSwitch: json['switch'] as bool?,
      num: (json['num'] as num?)?.toInt(),
      textSmall: json['text_small'] as String?,
      textLarge: json['text_large'] as String?,
      icon: json['icon'] as String?,
      iconLocation: json['icon_location'] as String?,
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

Nameplate _$NameplateFromJson(Map<String, dynamic> json) => Nameplate(
      nid: (json['nid'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      imageSmall: json['image_small'] as String?,
      level: json['level'] as String?,
      condition: json['condition'] as String?,
    );

Map<String, dynamic> _$NameplateToJson(Nameplate instance) => <String, dynamic>{
      'nid': instance.nid,
      'name': instance.name,
      'image': instance.image,
      'image_small': instance.imageSmall,
      'level': instance.level,
      'condition': instance.condition,
    };

Official _$OfficialFromJson(Map<String, dynamic> json) => Official(
      role: (json['role'] as num?)?.toInt(),
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OfficialToJson(Official instance) => <String, dynamic>{
      'role': instance.role,
      'title': instance.title,
      'desc': instance.desc,
      'type': instance.type,
    };

Pendant _$PendantFromJson(Map<String, dynamic> json) => Pendant(
      pid: (json['pid'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      expire: (json['expire'] as num?)?.toInt(),
      imageEnhance: json['image_enhance'] as String?,
      imageEnhanceFrame: json['image_enhance_frame'] as String?,
      nPid: (json['n_pid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PendantToJson(Pendant instance) => <String, dynamic>{
      'pid': instance.pid,
      'name': instance.name,
      'image': instance.image,
      'expire': instance.expire,
      'image_enhance': instance.imageEnhance,
      'image_enhance_frame': instance.imageEnhanceFrame,
      'n_pid': instance.nPid,
    };

Profession _$ProfessionFromJson(Map<String, dynamic> json) => Profession(
      name: json['name'] as String?,
      department: json['department'] as String?,
      title: json['title'] as String?,
      isShow: (json['is_show'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfessionToJson(Profession instance) =>
    <String, dynamic>{
      'name': instance.name,
      'department': instance.department,
      'title': instance.title,
      'is_show': instance.isShow,
    };

School _$SchoolFromJson(Map<String, dynamic> json) => School(
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SchoolToJson(School instance) => <String, dynamic>{
      'name': instance.name,
    };

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
      userUpgradeStatus: (json['user_upgrade_status'] as num?)?.toInt(),
      showUpgradeWindow: json['show_upgrade_window'] as bool?,
    );

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'user_upgrade_status': instance.userUpgradeStatus,
      'show_upgrade_window': instance.showUpgradeWindow,
    };

SysNotice _$SysNoticeFromJson(Map<String, dynamic> json) => SysNotice();

Map<String, dynamic> _$SysNoticeToJson(SysNotice instance) =>
    <String, dynamic>{};

TopPhotoV2 _$TopPhotoV2FromJson(Map<String, dynamic> json) => TopPhotoV2(
      sid: (json['sid'] as num?)?.toInt(),
      lImg: json['l_img'] as String?,
      l200HImg: json['l_200h_img'] as String?,
    );

Map<String, dynamic> _$TopPhotoV2ToJson(TopPhotoV2 instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'l_img': instance.lImg,
      'l_200h_img': instance.l200HImg,
    };

UserHonourInfo _$UserHonourInfoFromJson(Map<String, dynamic> json) =>
    UserHonourInfo(
      mid: (json['mid'] as num?)?.toInt(),
      colour: json['colour'],
      tags: json['tags'] as List<dynamic>?,
      isLatest100Honour: (json['is_latest_100honour'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserHonourInfoToJson(UserHonourInfo instance) =>
    <String, dynamic>{
      'mid': instance.mid,
      'colour': instance.colour,
      'tags': instance.tags,
      'is_latest_100honour': instance.isLatest100Honour,
    };

Vip _$VipFromJson(Map<String, dynamic> json) => Vip(
      type: (json['type'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      dueDate: (json['due_date'] as num?)?.toInt(),
      vipPayType: (json['vip_pay_type'] as num?)?.toInt(),
      themeType: (json['theme_type'] as num?)?.toInt(),
      label: json['label'] == null
          ? null
          : Label.fromJson(json['label'] as Map<String, dynamic>),
      avatarSubscript: (json['avatar_subscript'] as num?)?.toInt(),
      nicknameColor: json['nickname_color'] as String?,
      role: (json['role'] as num?)?.toInt(),
      avatarSubscriptUrl: json['avatar_subscript_url'] as String?,
      tvVipStatus: (json['tv_vip_status'] as num?)?.toInt(),
      tvVipPayType: (json['tv_vip_pay_type'] as num?)?.toInt(),
      tvDueDate: (json['tv_due_date'] as num?)?.toInt(),
      avatarIcon: json['avatar_icon'] == null
          ? null
          : AvatarIcon.fromJson(json['avatar_icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VipToJson(Vip instance) => <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
      'due_date': instance.dueDate,
      'vip_pay_type': instance.vipPayType,
      'theme_type': instance.themeType,
      'label': instance.label,
      'avatar_subscript': instance.avatarSubscript,
      'nickname_color': instance.nicknameColor,
      'role': instance.role,
      'avatar_subscript_url': instance.avatarSubscriptUrl,
      'tv_vip_status': instance.tvVipStatus,
      'tv_vip_pay_type': instance.tvVipPayType,
      'tv_due_date': instance.tvDueDate,
      'avatar_icon': instance.avatarIcon,
    };

AvatarIcon _$AvatarIconFromJson(Map<String, dynamic> json) => AvatarIcon(
      iconType: (json['icon_type'] as num?)?.toInt(),
      iconResource: json['icon_resource'] == null
          ? null
          : SysNotice.fromJson(json['icon_resource'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AvatarIconToJson(AvatarIcon instance) =>
    <String, dynamic>{
      'icon_type': instance.iconType,
      'icon_resource': instance.iconResource,
    };

Label _$LabelFromJson(Map<String, dynamic> json) => Label(
      path: json['path'] as String?,
      text: json['text'] as String?,
      labelTheme: json['label_theme'] as String?,
      textColor: json['text_color'] as String?,
      bgStyle: (json['bg_style'] as num?)?.toInt(),
      bgColor: json['bg_color'] as String?,
      borderColor: json['border_color'] as String?,
      useImgLabel: json['use_img_label'] as bool?,
      imgLabelUriHans: json['img_label_uri_hans'] as String?,
      imgLabelUriHant: json['img_label_uri_hant'] as String?,
      imgLabelUriHansStatic: json['img_label_uri_hans_static'] as String?,
      imgLabelUriHantStatic: json['img_label_uri_hant_static'] as String?,
    );

Map<String, dynamic> _$LabelToJson(Label instance) => <String, dynamic>{
      'path': instance.path,
      'text': instance.text,
      'label_theme': instance.labelTheme,
      'text_color': instance.textColor,
      'bg_style': instance.bgStyle,
      'bg_color': instance.bgColor,
      'border_color': instance.borderColor,
      'use_img_label': instance.useImgLabel,
      'img_label_uri_hans': instance.imgLabelUriHans,
      'img_label_uri_hant': instance.imgLabelUriHant,
      'img_label_uri_hans_static': instance.imgLabelUriHansStatic,
      'img_label_uri_hant_static': instance.imgLabelUriHantStatic,
    };
