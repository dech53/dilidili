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
  Card card;
  bool following;
  int archiveCount;
  int articleCount;
  int follower;
  int likeNum;

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
  String mid;
  bool approve;
  String name;
  String sex;
  String face;
  @JsonKey(name: 'face_nft')
  int faceNft;
  @JsonKey(name: 'face_nft_type')
  int faceNftType;
  @JsonKey(name: 'DisplayRank')
  String displayRank;
  int regtime;
  int spacesta;
  String birthday;
  String place;
  String description;
  int article;
  List<dynamic> attentions;
  int fans;
  int friend;
  int attention;
  String sign;
  LevelInfo levelInfo;
  Pendant? pendant;
  Nameplate? nameplate;
  @JsonKey(name: 'Official')
  Official? official;
  OfficialVerify? officialVerify;
  Vip vip;
  @JsonKey(name: 'is_senior_member')
  int isSeniorMember;
  dynamic nameRender; // 根据实际类型调整

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
  int currentLevel;
  int currentMin;
  int currentExp;
  int nextExp;

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
  int pid;
  String name;
  String image;
  int expire;
  String imageEnhance;
  String imageEnhanceFrame;
  int nPid;

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
  int nid;
  String name;
  String image;
  String imageSmall;
  String level;
  String condition;

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
  int role;
  String title;
  String desc;
  int type;

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
  int type;
  String desc;

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
  int type;
  int status;
  @JsonKey(name: 'due_date')
  int dueDate;
  @JsonKey(name: 'vip_pay_type')
  int vipPayType;
  @JsonKey(name: 'theme_type')
  int themeType;
  VipLabel label;
  @JsonKey(name: 'avatar_subscript')
  int avatarSubscript;
  @JsonKey(name: 'nickname_color')
  String nicknameColor;
  int role;
  @JsonKey(name: 'avatar_subscript_url')
  String avatarSubscriptUrl;
  @JsonKey(name: 'tv_vip_status')
  int tvVipStatus;
  @JsonKey(name: 'tv_vip_pay_type')
  int tvVipPayType;
  @JsonKey(name: 'tv_due_date')
  int tvDueDate;
  @JsonKey(name: 'avatar_icon')
  AvatarIcon avatarIcon;
  @JsonKey(name: 'vipType')
  int vipType;
  @JsonKey(name: 'vipStatus')
  int vipStatus;

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
  String sImg;
  String lImg;

  Space({
    required this.sImg,
    required this.lImg,
  });
  factory Space.fromJson(Map<String, dynamic> json) => _$SpaceFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VipLabel {
  String path;
  String text;
  String labelTheme;
  String textColor;
  int bgStyle;
  String bgColor;
  String borderColor;
  bool useImgLabel;
  String imgLabelUriHans;
  String imgLabelUriHant;
  String imgLabelUriHansStatic;
  String imgLabelUriHantStatic;

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
  int? iconType;
  Map<String, dynamic> iconResource;

  AvatarIcon({
    this.iconType,
    required this.iconResource,
  });

  factory AvatarIcon.fromJson(Map<String, dynamic> json) =>
      _$AvatarIconFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarIconToJson(this);
}
