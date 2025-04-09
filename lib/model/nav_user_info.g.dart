// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavUserInfo _$NavUserInfoFromJson(Map<String, dynamic> json) => NavUserInfo(
      isLogin: json['isLogin'] as bool,
      wbi_img: WbiImg.fromJson(json['wbi_img'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NavUserInfoToJson(NavUserInfo instance) =>
    <String, dynamic>{
      'isLogin': instance.isLogin,
      'wbi_img': instance.wbi_img.toJson(),
    };

WbiImg _$WbiImgFromJson(Map<String, dynamic> json) => WbiImg(
      img_url: json['img_url'] as String,
      sub_url: json['sub_url'] as String,
    );

Map<String, dynamic> _$WbiImgToJson(WbiImg instance) => <String, dynamic>{
      'img_url': instance.img_url,
      'sub_url': instance.sub_url,
    };

UserCardInfo _$UserCardInfoFromJson(Map<String, dynamic> json) => UserCardInfo(
      card: Card.fromJson(json['card'] as Map<String, dynamic>),
      following: json['following'] as bool,
      archiveCount: (json['archive_count'] as num).toInt(),
      articleCount: (json['article_count'] as num).toInt(),
      follower: (json['follower'] as num).toInt(),
      likeNum: (json['like_num'] as num).toInt(),
    );

Map<String, dynamic> _$UserCardInfoToJson(UserCardInfo instance) =>
    <String, dynamic>{
      'card': instance.card,
      'following': instance.following,
      'archive_count': instance.archiveCount,
      'article_count': instance.articleCount,
      'follower': instance.follower,
      'like_num': instance.likeNum,
    };

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      mid: json['mid'] as String,
      approve: json['approve'] as bool,
      name: json['name'] as String,
      sex: json['sex'] as String,
      face: json['face'] as String,
      faceNft: (json['face_nft'] as num).toInt(),
      faceNftType: (json['face_nft_type'] as num).toInt(),
      displayRank: json['DisplayRank'] as String,
      regtime: (json['regtime'] as num).toInt(),
      spacesta: (json['spacesta'] as num).toInt(),
      birthday: json['birthday'] as String,
      place: json['place'] as String,
      description: json['description'] as String,
      article: (json['article'] as num).toInt(),
      attentions: json['attentions'] as List<dynamic>,
      fans: (json['fans'] as num).toInt(),
      friend: (json['friend'] as num).toInt(),
      attention: (json['attention'] as num).toInt(),
      sign: json['sign'] as String,
      levelInfo: LevelInfo.fromJson(json['level_info'] as Map<String, dynamic>),
      pendant: json['pendant'] == null
          ? null
          : Pendant.fromJson(json['pendant'] as Map<String, dynamic>),
      nameplate: json['nameplate'] == null
          ? null
          : Nameplate.fromJson(json['nameplate'] as Map<String, dynamic>),
      official: json['Official'] == null
          ? null
          : Official.fromJson(json['Official'] as Map<String, dynamic>),
      officialVerify: json['official_verify'] == null
          ? null
          : OfficialVerify.fromJson(
              json['official_verify'] as Map<String, dynamic>),
      vip: Vip.fromJson(json['vip'] as Map<String, dynamic>),
      isSeniorMember: (json['is_senior_member'] as num).toInt(),
      nameRender: json['name_render'],
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'mid': instance.mid,
      'approve': instance.approve,
      'name': instance.name,
      'sex': instance.sex,
      'face': instance.face,
      'face_nft': instance.faceNft,
      'face_nft_type': instance.faceNftType,
      'DisplayRank': instance.displayRank,
      'regtime': instance.regtime,
      'spacesta': instance.spacesta,
      'birthday': instance.birthday,
      'place': instance.place,
      'description': instance.description,
      'article': instance.article,
      'attentions': instance.attentions,
      'fans': instance.fans,
      'friend': instance.friend,
      'attention': instance.attention,
      'sign': instance.sign,
      'level_info': instance.levelInfo,
      'pendant': instance.pendant,
      'nameplate': instance.nameplate,
      'Official': instance.official,
      'official_verify': instance.officialVerify,
      'vip': instance.vip,
      'is_senior_member': instance.isSeniorMember,
      'name_render': instance.nameRender,
    };

LevelInfo _$LevelInfoFromJson(Map<String, dynamic> json) => LevelInfo(
      currentLevel: (json['current_level'] as num).toInt(),
      currentMin: (json['current_min'] as num).toInt(),
      currentExp: (json['current_exp'] as num).toInt(),
      nextExp: (json['next_exp'] as num).toInt(),
    );

Map<String, dynamic> _$LevelInfoToJson(LevelInfo instance) => <String, dynamic>{
      'current_level': instance.currentLevel,
      'current_min': instance.currentMin,
      'current_exp': instance.currentExp,
      'next_exp': instance.nextExp,
    };

Pendant _$PendantFromJson(Map<String, dynamic> json) => Pendant(
      pid: (json['pid'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String,
      expire: (json['expire'] as num).toInt(),
      imageEnhance: json['image_enhance'] as String,
      imageEnhanceFrame: json['image_enhance_frame'] as String,
      nPid: (json['n_pid'] as num).toInt(),
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

Nameplate _$NameplateFromJson(Map<String, dynamic> json) => Nameplate(
      nid: (json['nid'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String,
      imageSmall: json['image_small'] as String,
      level: json['level'] as String,
      condition: json['condition'] as String,
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
      role: (json['role'] as num).toInt(),
      title: json['title'] as String,
      desc: json['desc'] as String,
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$OfficialToJson(Official instance) => <String, dynamic>{
      'role': instance.role,
      'title': instance.title,
      'desc': instance.desc,
      'type': instance.type,
    };

OfficialVerify _$OfficialVerifyFromJson(Map<String, dynamic> json) =>
    OfficialVerify(
      type: (json['type'] as num).toInt(),
      desc: json['desc'] as String,
    );

Map<String, dynamic> _$OfficialVerifyToJson(OfficialVerify instance) =>
    <String, dynamic>{
      'type': instance.type,
      'desc': instance.desc,
    };

Vip _$VipFromJson(Map<String, dynamic> json) => Vip(
      type: (json['type'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      dueDate: (json['due_date'] as num).toInt(),
      vipPayType: (json['vip_pay_type'] as num).toInt(),
      themeType: (json['theme_type'] as num).toInt(),
      label: VipLabel.fromJson(json['label'] as Map<String, dynamic>),
      avatarSubscript: (json['avatar_subscript'] as num).toInt(),
      nicknameColor: json['nickname_color'] as String,
      role: (json['role'] as num).toInt(),
      avatarSubscriptUrl: json['avatar_subscript_url'] as String,
      tvVipStatus: (json['tv_vip_status'] as num).toInt(),
      tvVipPayType: (json['tv_vip_pay_type'] as num).toInt(),
      tvDueDate: (json['tv_due_date'] as num).toInt(),
      avatarIcon:
          AvatarIcon.fromJson(json['avatar_icon'] as Map<String, dynamic>),
      vipType: (json['vipType'] as num).toInt(),
      vipStatus: (json['vipStatus'] as num).toInt(),
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
      'vipType': instance.vipType,
      'vipStatus': instance.vipStatus,
    };

Space _$SpaceFromJson(Map<String, dynamic> json) => Space(
      sImg: json['s_img'] as String,
      lImg: json['l_img'] as String,
    );

Map<String, dynamic> _$SpaceToJson(Space instance) => <String, dynamic>{
      's_img': instance.sImg,
      'l_img': instance.lImg,
    };

VipLabel _$VipLabelFromJson(Map<String, dynamic> json) => VipLabel(
      path: json['path'] as String,
      text: json['text'] as String,
      labelTheme: json['label_theme'] as String,
      textColor: json['text_color'] as String,
      bgStyle: (json['bg_style'] as num).toInt(),
      bgColor: json['bg_color'] as String,
      borderColor: json['border_color'] as String,
      useImgLabel: json['use_img_label'] as bool,
      imgLabelUriHans: json['img_label_uri_hans'] as String,
      imgLabelUriHant: json['img_label_uri_hant'] as String,
      imgLabelUriHansStatic: json['img_label_uri_hans_static'] as String,
      imgLabelUriHantStatic: json['img_label_uri_hant_static'] as String,
    );

Map<String, dynamic> _$VipLabelToJson(VipLabel instance) => <String, dynamic>{
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

AvatarIcon _$AvatarIconFromJson(Map<String, dynamic> json) => AvatarIcon(
      iconType: (json['icon_type'] as num?)?.toInt(),
      iconResource: json['icon_resource'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AvatarIconToJson(AvatarIcon instance) =>
    <String, dynamic>{
      'icon_type': instance.iconType,
      'icon_resource': instance.iconResource,
    };
