import 'package:json_annotation/json_annotation.dart';
part 'member_info.g.dart';
@JsonSerializable()
class MemberInfo {
    @JsonKey(name: "mid")
    int? mid;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "sex")
    String? sex;
    @JsonKey(name: "face")
    String? face;
    @JsonKey(name: "face_nft")
    int? faceNft;
    @JsonKey(name: "face_nft_type")
    int? faceNftType;
    @JsonKey(name: "sign")
    String? sign;
    @JsonKey(name: "rank")
    int? rank;
    @JsonKey(name: "level")
    int? level;
    @JsonKey(name: "jointime")
    int? jointime;
    @JsonKey(name: "moral")
    int? moral;
    @JsonKey(name: "silence")
    int? silence;
    @JsonKey(name: "coins")
    double? coins;
    @JsonKey(name: "fans_badge")
    bool? fansBadge;
    @JsonKey(name: "fans_medal")
    FansMedal? fansMedal;
    @JsonKey(name: "official")
    Official? official;
    @JsonKey(name: "vip")
    Vip? vip;
    @JsonKey(name: "pendant")
    Pendant? pendant;
    @JsonKey(name: "nameplate")
    Nameplate? nameplate;
    @JsonKey(name: "user_honour_info")
    UserHonourInfo? userHonourInfo;
    @JsonKey(name: "is_followed")
    bool? isFollowed;
    @JsonKey(name: "top_photo")
    String? topPhoto;
    @JsonKey(name: "sys_notice")
    SysNotice? sysNotice;
    @JsonKey(name: "live_room")
    LiveRoom? liveRoom;
    @JsonKey(name: "birthday")
    String? birthday;
    @JsonKey(name: "school")
    School? school;
    @JsonKey(name: "profession")
    Profession? profession;
    @JsonKey(name: "tags")
    dynamic tags;
    @JsonKey(name: "series")
    Series? series;
    @JsonKey(name: "is_senior_member")
    int? isSeniorMember;
    @JsonKey(name: "mcn_info")
    dynamic mcnInfo;
    @JsonKey(name: "gaia_res_type")
    int? gaiaResType;
    @JsonKey(name: "gaia_data")
    dynamic gaiaData;
    @JsonKey(name: "is_risk")
    bool? isRisk;
    @JsonKey(name: "elec")
    Elec? elec;
    @JsonKey(name: "contract")
    Contract? contract;
    @JsonKey(name: "certificate_show")
    bool? certificateShow;
    @JsonKey(name: "name_render")
    dynamic nameRender;
    @JsonKey(name: "top_photo_v2")
    TopPhotoV2? topPhotoV2;
    @JsonKey(name: "theme")
    dynamic theme;
    @JsonKey(name: "attestation")
    Attestation? attestation;

    MemberInfo({
        this.mid,
        this.name,
        this.sex,
        this.face,
        this.faceNft,
        this.faceNftType,
        this.sign,
        this.rank,
        this.level,
        this.jointime,
        this.moral,
        this.silence,
        this.coins,
        this.fansBadge,
        this.fansMedal,
        this.official,
        this.vip,
        this.pendant,
        this.nameplate,
        this.userHonourInfo,
        this.isFollowed,
        this.topPhoto,
        this.sysNotice,
        this.liveRoom,
        this.birthday,
        this.school,
        this.profession,
        this.tags,
        this.series,
        this.isSeniorMember,
        this.mcnInfo,
        this.gaiaResType,
        this.gaiaData,
        this.isRisk,
        this.elec,
        this.contract,
        this.certificateShow,
        this.nameRender,
        this.topPhotoV2,
        this.theme,
        this.attestation,
    });

    factory MemberInfo.fromJson(Map<String, dynamic> json) => _$MemberInfoFromJson(json);

    Map<String, dynamic> toJson() => _$MemberInfoToJson(this);
}

@JsonSerializable()
class Attestation {
    @JsonKey(name: "type")
    int? type;
    @JsonKey(name: "common_info")
    CommonInfo? commonInfo;
    @JsonKey(name: "splice_info")
    SpliceInfo? spliceInfo;
    @JsonKey(name: "icon")
    String? icon;
    @JsonKey(name: "desc")
    String? desc;

    Attestation({
        this.type,
        this.commonInfo,
        this.spliceInfo,
        this.icon,
        this.desc,
    });

    factory Attestation.fromJson(Map<String, dynamic> json) => _$AttestationFromJson(json);

    Map<String, dynamic> toJson() => _$AttestationToJson(this);
}

@JsonSerializable()
class CommonInfo {
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "prefix")
    String? prefix;
    @JsonKey(name: "prefix_title")
    String? prefixTitle;

    CommonInfo({
        this.title,
        this.prefix,
        this.prefixTitle,
    });

    factory CommonInfo.fromJson(Map<String, dynamic> json) => _$CommonInfoFromJson(json);

    Map<String, dynamic> toJson() => _$CommonInfoToJson(this);
}

@JsonSerializable()
class SpliceInfo {
    @JsonKey(name: "title")
    String? title;

    SpliceInfo({
        this.title,
    });

    factory SpliceInfo.fromJson(Map<String, dynamic> json) => _$SpliceInfoFromJson(json);

    Map<String, dynamic> toJson() => _$SpliceInfoToJson(this);
}

@JsonSerializable()
class Contract {
    @JsonKey(name: "is_display")
    bool? isDisplay;
    @JsonKey(name: "is_follow_display")
    bool? isFollowDisplay;

    Contract({
        this.isDisplay,
        this.isFollowDisplay,
    });

    factory Contract.fromJson(Map<String, dynamic> json) => _$ContractFromJson(json);

    Map<String, dynamic> toJson() => _$ContractToJson(this);
}

@JsonSerializable()
class Elec {
    @JsonKey(name: "show_info")
    ShowInfo? showInfo;

    Elec({
        this.showInfo,
    });

    factory Elec.fromJson(Map<String, dynamic> json) => _$ElecFromJson(json);

    Map<String, dynamic> toJson() => _$ElecToJson(this);
}

@JsonSerializable()
class ShowInfo {
    @JsonKey(name: "show")
    bool? show;
    @JsonKey(name: "state")
    int? state;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "icon")
    String? icon;
    @JsonKey(name: "jump_url")
    String? jumpUrl;

    ShowInfo({
        this.show,
        this.state,
        this.title,
        this.icon,
        this.jumpUrl,
    });

    factory ShowInfo.fromJson(Map<String, dynamic> json) => _$ShowInfoFromJson(json);

    Map<String, dynamic> toJson() => _$ShowInfoToJson(this);
}

@JsonSerializable()
class FansMedal {
    @JsonKey(name: "show")
    bool? show;
    @JsonKey(name: "wear")
    bool? wear;
    @JsonKey(name: "medal")
    Medal? medal;

    FansMedal({
        this.show,
        this.wear,
        this.medal,
    });

    factory FansMedal.fromJson(Map<String, dynamic> json) => _$FansMedalFromJson(json);

    Map<String, dynamic> toJson() => _$FansMedalToJson(this);
}

@JsonSerializable()
class Medal {
    @JsonKey(name: "uid")
    int? uid;
    @JsonKey(name: "target_id")
    int? targetId;
    @JsonKey(name: "medal_id")
    int? medalId;
    @JsonKey(name: "level")
    int? level;
    @JsonKey(name: "medal_name")
    String? medalName;
    @JsonKey(name: "medal_color")
    int? medalColor;
    @JsonKey(name: "intimacy")
    int? intimacy;
    @JsonKey(name: "next_intimacy")
    int? nextIntimacy;
    @JsonKey(name: "day_limit")
    int? dayLimit;
    @JsonKey(name: "medal_color_start")
    int? medalColorStart;
    @JsonKey(name: "medal_color_end")
    int? medalColorEnd;
    @JsonKey(name: "medal_color_border")
    int? medalColorBorder;
    @JsonKey(name: "is_lighted")
    int? isLighted;
    @JsonKey(name: "light_status")
    int? lightStatus;
    @JsonKey(name: "wearing_status")
    int? wearingStatus;
    @JsonKey(name: "score")
    int? score;

    Medal({
        this.uid,
        this.targetId,
        this.medalId,
        this.level,
        this.medalName,
        this.medalColor,
        this.intimacy,
        this.nextIntimacy,
        this.dayLimit,
        this.medalColorStart,
        this.medalColorEnd,
        this.medalColorBorder,
        this.isLighted,
        this.lightStatus,
        this.wearingStatus,
        this.score,
    });

    factory Medal.fromJson(Map<String, dynamic> json) => _$MedalFromJson(json);

    Map<String, dynamic> toJson() => _$MedalToJson(this);
}

@JsonSerializable()
class LiveRoom {
    @JsonKey(name: "roomStatus")
    int? roomStatus;
    @JsonKey(name: "liveStatus")
    int? liveStatus;
    @JsonKey(name: "url")
    String? url;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "cover")
    String? cover;
    @JsonKey(name: "roomid")
    int? roomid;
    @JsonKey(name: "roundStatus")
    int? roundStatus;
    @JsonKey(name: "broadcast_type")
    int? broadcastType;
    @JsonKey(name: "watched_show")
    WatchedShow? watchedShow;

    LiveRoom({
        this.roomStatus,
        this.liveStatus,
        this.url,
        this.title,
        this.cover,
        this.roomid,
        this.roundStatus,
        this.broadcastType,
        this.watchedShow,
    });

    factory LiveRoom.fromJson(Map<String, dynamic> json) => _$LiveRoomFromJson(json);

    Map<String, dynamic> toJson() => _$LiveRoomToJson(this);
}

@JsonSerializable()
class WatchedShow {
    @JsonKey(name: "switch")
    bool? watchedShowSwitch;
    @JsonKey(name: "num")
    int? num;
    @JsonKey(name: "text_small")
    String? textSmall;
    @JsonKey(name: "text_large")
    String? textLarge;
    @JsonKey(name: "icon")
    String? icon;
    @JsonKey(name: "icon_location")
    String? iconLocation;
    @JsonKey(name: "icon_web")
    String? iconWeb;

    WatchedShow({
        this.watchedShowSwitch,
        this.num,
        this.textSmall,
        this.textLarge,
        this.icon,
        this.iconLocation,
        this.iconWeb,
    });

    factory WatchedShow.fromJson(Map<String, dynamic> json) => _$WatchedShowFromJson(json);

    Map<String, dynamic> toJson() => _$WatchedShowToJson(this);
}

@JsonSerializable()
class Nameplate {
    @JsonKey(name: "nid")
    int? nid;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "image")
    String? image;
    @JsonKey(name: "image_small")
    String? imageSmall;
    @JsonKey(name: "level")
    String? level;
    @JsonKey(name: "condition")
    String? condition;

    Nameplate({
        this.nid,
        this.name,
        this.image,
        this.imageSmall,
        this.level,
        this.condition,
    });

    factory Nameplate.fromJson(Map<String, dynamic> json) => _$NameplateFromJson(json);

    Map<String, dynamic> toJson() => _$NameplateToJson(this);
}

@JsonSerializable()
class Official {
    @JsonKey(name: "role")
    int? role;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "desc")
    String? desc;
    @JsonKey(name: "type")
    int? type;

    Official({
        this.role,
        this.title,
        this.desc,
        this.type,
    });

    factory Official.fromJson(Map<String, dynamic> json) => _$OfficialFromJson(json);

    Map<String, dynamic> toJson() => _$OfficialToJson(this);
}

@JsonSerializable()
class Pendant {
    @JsonKey(name: "pid")
    int? pid;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "image")
    String? image;
    @JsonKey(name: "expire")
    int? expire;
    @JsonKey(name: "image_enhance")
    String? imageEnhance;
    @JsonKey(name: "image_enhance_frame")
    String? imageEnhanceFrame;
    @JsonKey(name: "n_pid")
    int? nPid;

    Pendant({
        this.pid,
        this.name,
        this.image,
        this.expire,
        this.imageEnhance,
        this.imageEnhanceFrame,
        this.nPid,
    });

    factory Pendant.fromJson(Map<String, dynamic> json) => _$PendantFromJson(json);

    Map<String, dynamic> toJson() => _$PendantToJson(this);
}

@JsonSerializable()
class Profession {
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "department")
    String? department;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "is_show")
    int? isShow;

    Profession({
        this.name,
        this.department,
        this.title,
        this.isShow,
    });

    factory Profession.fromJson(Map<String, dynamic> json) => _$ProfessionFromJson(json);

    Map<String, dynamic> toJson() => _$ProfessionToJson(this);
}

@JsonSerializable()
class School {
    @JsonKey(name: "name")
    String? name;

    School({
        this.name,
    });

    factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);

    Map<String, dynamic> toJson() => _$SchoolToJson(this);
}

@JsonSerializable()
class Series {
    @JsonKey(name: "user_upgrade_status")
    int? userUpgradeStatus;
    @JsonKey(name: "show_upgrade_window")
    bool? showUpgradeWindow;

    Series({
        this.userUpgradeStatus,
        this.showUpgradeWindow,
    });

    factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

    Map<String, dynamic> toJson() => _$SeriesToJson(this);
}

@JsonSerializable()
class SysNotice {
    SysNotice();

    factory SysNotice.fromJson(Map<String, dynamic> json) => _$SysNoticeFromJson(json);

    Map<String, dynamic> toJson() => _$SysNoticeToJson(this);
}

@JsonSerializable()
class TopPhotoV2 {
    @JsonKey(name: "sid")
    int? sid;
    @JsonKey(name: "l_img")
    String? lImg;
    @JsonKey(name: "l_200h_img")
    String? l200HImg;

    TopPhotoV2({
        this.sid,
        this.lImg,
        this.l200HImg,
    });

    factory TopPhotoV2.fromJson(Map<String, dynamic> json) => _$TopPhotoV2FromJson(json);

    Map<String, dynamic> toJson() => _$TopPhotoV2ToJson(this);
}

@JsonSerializable()
class UserHonourInfo {
    @JsonKey(name: "mid")
    int? mid;
    @JsonKey(name: "colour")
    dynamic colour;
    @JsonKey(name: "tags")
    List<dynamic>? tags;
    @JsonKey(name: "is_latest_100honour")
    int? isLatest100Honour;

    UserHonourInfo({
        this.mid,
        this.colour,
        this.tags,
        this.isLatest100Honour,
    });

    factory UserHonourInfo.fromJson(Map<String, dynamic> json) => _$UserHonourInfoFromJson(json);

    Map<String, dynamic> toJson() => _$UserHonourInfoToJson(this);
}

@JsonSerializable()
class Vip {
    @JsonKey(name: "type")
    int? type;
    @JsonKey(name: "status")
    int? status;
    @JsonKey(name: "due_date")
    int? dueDate;
    @JsonKey(name: "vip_pay_type")
    int? vipPayType;
    @JsonKey(name: "theme_type")
    int? themeType;
    @JsonKey(name: "label")
    Label? label;
    @JsonKey(name: "avatar_subscript")
    int? avatarSubscript;
    @JsonKey(name: "nickname_color")
    String? nicknameColor;
    @JsonKey(name: "role")
    int? role;
    @JsonKey(name: "avatar_subscript_url")
    String? avatarSubscriptUrl;
    @JsonKey(name: "tv_vip_status")
    int? tvVipStatus;
    @JsonKey(name: "tv_vip_pay_type")
    int? tvVipPayType;
    @JsonKey(name: "tv_due_date")
    int? tvDueDate;
    @JsonKey(name: "avatar_icon")
    AvatarIcon? avatarIcon;

    Vip({
        this.type,
        this.status,
        this.dueDate,
        this.vipPayType,
        this.themeType,
        this.label,
        this.avatarSubscript,
        this.nicknameColor,
        this.role,
        this.avatarSubscriptUrl,
        this.tvVipStatus,
        this.tvVipPayType,
        this.tvDueDate,
        this.avatarIcon,
    });

    factory Vip.fromJson(Map<String, dynamic> json) => _$VipFromJson(json);

    Map<String, dynamic> toJson() => _$VipToJson(this);
}

@JsonSerializable()
class AvatarIcon {
    @JsonKey(name: "icon_type")
    int? iconType;
    @JsonKey(name: "icon_resource")
    SysNotice? iconResource;

    AvatarIcon({
        this.iconType,
        this.iconResource,
    });

    factory AvatarIcon.fromJson(Map<String, dynamic> json) => _$AvatarIconFromJson(json);

    Map<String, dynamic> toJson() => _$AvatarIconToJson(this);
}

@JsonSerializable()
class Label {
    @JsonKey(name: "path")
    String? path;
    @JsonKey(name: "text")
    String? text;
    @JsonKey(name: "label_theme")
    String? labelTheme;
    @JsonKey(name: "text_color")
    String? textColor;
    @JsonKey(name: "bg_style")
    int? bgStyle;
    @JsonKey(name: "bg_color")
    String? bgColor;
    @JsonKey(name: "border_color")
    String? borderColor;
    @JsonKey(name: "use_img_label")
    bool? useImgLabel;
    @JsonKey(name: "img_label_uri_hans")
    String? imgLabelUriHans;
    @JsonKey(name: "img_label_uri_hant")
    String? imgLabelUriHant;
    @JsonKey(name: "img_label_uri_hans_static")
    String? imgLabelUriHansStatic;
    @JsonKey(name: "img_label_uri_hant_static")
    String? imgLabelUriHantStatic;

    Label({
        this.path,
        this.text,
        this.labelTheme,
        this.textColor,
        this.bgStyle,
        this.bgColor,
        this.borderColor,
        this.useImgLabel,
        this.imgLabelUriHans,
        this.imgLabelUriHant,
        this.imgLabelUriHansStatic,
        this.imgLabelUriHantStatic,
    });

    factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

    Map<String, dynamic> toJson() => _$LabelToJson(this);
}
