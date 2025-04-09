import 'package:json_annotation/json_annotation.dart';
part 'nav_user_info.g.dart';

@JsonSerializable(explicitToJson: true)
class NavUserInfo {
  bool isLogin;
  WbiImg wbi_img;
  NavUserInfo({required this.isLogin, required this.wbi_img});
  factory NavUserInfo.fromJson(Map<String, dynamic> json) =>
      _$NavUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$NavUserInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WbiImg {
  String img_url;
  String sub_url;
  WbiImg({required this.img_url, required this.sub_url});
  factory WbiImg.fromJson(Map<String, dynamic> json) => _$WbiImgFromJson(json);
  Map<String, dynamic> toJson() => _$WbiImgToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserCardInfo {
  final Card card;
  final bool following;
  final int archiveCount;
  final int articleCount;
  final int follower;
  final int likeNum;

  UserCardInfo({
    required this.card,
    required this.following,
    required this.archiveCount,
    required this.articleCount,
    required this.follower,
    required this.likeNum,
  });
  factory UserCardInfo.fromJson(Map<String, dynamic> json) =>
      _$UserCardInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserCardInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Card {
  final String mid;
  final bool approve;
  final String name;
  final String sex;
  final String face;
  @JsonKey(name: 'face_nft')
  final int faceNft;
  @JsonKey(name: 'face_nft_type')
  final int faceNftType;
  @JsonKey(name: 'DisplayRank')
  final String displayRank;
  final int regtime;
  final int spacesta;
  final String birthday;
  final String place;
  final String description;
  final int article;
  final List<dynamic> attentions;
  final int fans;
  final int friend;
  final int attention;
  final String sign;
  final LevelInfo levelInfo;
  final Pendant? pendant;
  final Nameplate? nameplate;
  @JsonKey(name: 'Official')
  final Official? official;
  final OfficialVerify? officialVerify;
  final Vip vip;
  @JsonKey(name: 'is_senior_member')
  final int isSeniorMember;
  final dynamic nameRender; // 根据实际类型调整

  Card({
    required this.mid,
    required this.approve,
    required this.name,
    required this.sex,
    required this.face,
    required this.faceNft,
    required this.faceNftType,
    required this.displayRank,
    required this.regtime,
    required this.spacesta,
    required this.birthday,
    required this.place,
    required this.description,
    required this.article,
    required this.attentions,
    required this.fans,
    required this.friend,
    required this.attention,
    required this.sign,
    required this.levelInfo,
    this.pendant,
    this.nameplate,
    this.official,
    this.officialVerify,
    required this.vip,
    required this.isSeniorMember,
    this.nameRender,
  });

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
  Map<String, dynamic> toJson() => _$CardToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LevelInfo {
  final int currentLevel;
  final int currentMin;
  final int currentExp;
  final int nextExp;

  LevelInfo({
    required this.currentLevel,
    required this.currentMin,
    required this.currentExp,
    required this.nextExp,
  });
  factory LevelInfo.fromJson(Map<String, dynamic> json) =>
      _$LevelInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LevelInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Pendant {
  final int pid;
  final String name;
  final String image;
  final int expire;
  final String imageEnhance;
  final String imageEnhanceFrame;
  final int nPid;

  Pendant({
    required this.pid,
    required this.name,
    required this.image,
    required this.expire,
    required this.imageEnhance,
    required this.imageEnhanceFrame,
    required this.nPid,
  });
  factory Pendant.fromJson(Map<String, dynamic> json) =>
      _$PendantFromJson(json);
  Map<String, dynamic> toJson() => _$PendantToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Nameplate {
  final int nid;
  final String name;
  final String image;
  final String imageSmall;
  final String level;
  final String condition;

  Nameplate({
    required this.nid,
    required this.name,
    required this.image,
    required this.imageSmall,
    required this.level,
    required this.condition,
  });
  factory Nameplate.fromJson(Map<String, dynamic> json) =>
      _$NameplateFromJson(json);
  Map<String, dynamic> toJson() => _$NameplateToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Official {
  final int role;
  final String title;
  final String desc;
  final int type;

  Official({
    required this.role,
    required this.title,
    required this.desc,
    required this.type,
  });
  factory Official.fromJson(Map<String, dynamic> json) =>
      _$OfficialFromJson(json);
  Map<String, dynamic> toJson() => _$OfficialToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OfficialVerify {
  final int type;
  final String desc;

  OfficialVerify({
    required this.type,
    required this.desc,
  });
  factory OfficialVerify.fromJson(Map<String, dynamic> json) =>
      _$OfficialVerifyFromJson(json);
  Map<String, dynamic> toJson() => _$OfficialVerifyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Vip {
  final int type;
  final int status;
  @JsonKey(name: 'due_date')
  final int dueDate;
  @JsonKey(name: 'vip_pay_type')
  final int vipPayType;
  @JsonKey(name: 'theme_type')
  final int themeType;
  final VipLabel label;
  @JsonKey(name: 'avatar_subscript')
  final int avatarSubscript;
  @JsonKey(name: 'nickname_color')
  final String nicknameColor;
  final int role;
  @JsonKey(name: 'avatar_subscript_url')
  final String avatarSubscriptUrl;
  @JsonKey(name: 'tv_vip_status')
  final int tvVipStatus;
  @JsonKey(name: 'tv_vip_pay_type')
  final int tvVipPayType;
  @JsonKey(name: 'tv_due_date')
  final int tvDueDate;
  @JsonKey(name: 'avatar_icon')
  final AvatarIcon avatarIcon;
  @JsonKey(name: 'vipType')
  final int vipType;
  @JsonKey(name: 'vipStatus')
  final int vipStatus;

  Vip({
    required this.type,
    required this.status,
    required this.dueDate,
    required this.vipPayType,
    required this.themeType,
    required this.label,
    required this.avatarSubscript,
    required this.nicknameColor,
    required this.role,
    required this.avatarSubscriptUrl,
    required this.tvVipStatus,
    required this.tvVipPayType,
    required this.tvDueDate,
    required this.avatarIcon,
    required this.vipType,
    required this.vipStatus,
  });

  factory Vip.fromJson(Map<String, dynamic> json) => _$VipFromJson(json);
  Map<String, dynamic> toJson() => _$VipToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Space {
  final String sImg;
  final String lImg;

  Space({
    required this.sImg,
    required this.lImg,
  });
  factory Space.fromJson(Map<String, dynamic> json) => _$SpaceFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VipLabel {
  final String path;
  final String text;
  final String labelTheme;
  final String textColor;
  final int bgStyle;
  final String bgColor;
  final String borderColor;
  final bool useImgLabel;
  final String imgLabelUriHans;
  final String imgLabelUriHant;
  final String imgLabelUriHansStatic;
  final String imgLabelUriHantStatic;

  VipLabel({
    required this.path,
    required this.text,
    required this.labelTheme,
    required this.textColor,
    required this.bgStyle,
    required this.bgColor,
    required this.borderColor,
    required this.useImgLabel,
    required this.imgLabelUriHans,
    required this.imgLabelUriHant,
    required this.imgLabelUriHansStatic,
    required this.imgLabelUriHantStatic,
  });

  factory VipLabel.fromJson(Map<String, dynamic> json) =>
      _$VipLabelFromJson(json);
  Map<String, dynamic> toJson() => _$VipLabelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AvatarIcon {
  final int? iconType;
  final Map<String, dynamic> iconResource;

  AvatarIcon({
    this.iconType,
    required this.iconResource,
  });

  factory AvatarIcon.fromJson(Map<String, dynamic> json) =>
      _$AvatarIconFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarIconToJson(this);
}
