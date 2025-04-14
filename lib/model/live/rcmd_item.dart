import 'package:json_annotation/json_annotation.dart';
part 'rcmd_item.g.dart';
@JsonSerializable()
class RecommendLiveItems {
    @JsonKey(name: "recommend_room_list")
    List<RecommendLiveItem>? recommendRoomList;
    @JsonKey(name: "top_room_id")
    int? topRoomId;

    RecommendLiveItems({
        this.recommendRoomList,
        this.topRoomId,
    });

    factory RecommendLiveItems.fromJson(Map<String, dynamic> json) => _$RecommendLiveItemsFromJson(json);

    Map<String, dynamic> toJson() => _$RecommendLiveItemsToJson(this);
}

@JsonSerializable()
class RecommendLiveItem {
    @JsonKey(name: "head_box")
    HeadBox? headBox;
    @JsonKey(name: "area_v2_id")
    int? areaV2Id;
    @JsonKey(name: "area_v2_parent_id")
    int? areaV2ParentId;
    @JsonKey(name: "area_v2_name")
    String? areaV2Name;
    @JsonKey(name: "area_v2_parent_name")
    String? areaV2ParentName;
    @JsonKey(name: "broadcast_type")
    int? broadcastType;
    @JsonKey(name: "cover")
    String? cover;
    @JsonKey(name: "link")
    String? link;
    @JsonKey(name: "online")
    int? online;
    @JsonKey(name: "pendant_Info")
    PendantInfo? pendantInfo;
    @JsonKey(name: "roomid")
    int? roomid;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "uname")
    String? uname;
    @JsonKey(name: "face")
    String? face;
    @JsonKey(name: "verify")
    Verify? verify;
    @JsonKey(name: "uid")
    int? uid;
    @JsonKey(name: "keyframe")
    String? keyframe;
    @JsonKey(name: "is_auto_play")
    int? isAutoPlay;
    @JsonKey(name: "head_box_type")
    int? headBoxType;
    @JsonKey(name: "flag")
    int? flag;
    @JsonKey(name: "session_id")
    String? sessionId;
    @JsonKey(name: "group_id")
    int? groupId;
    @JsonKey(name: "show_callback")
    String? showCallback;
    @JsonKey(name: "click_callback")
    String? clickCallback;
    @JsonKey(name: "special_id")
    int? specialId;
    @JsonKey(name: "watched_show")
    WatchedShow? watchedShow;
    @JsonKey(name: "is_nft")
    int? isNft;
    @JsonKey(name: "nft_dmark")
    String? nftDmark;
    @JsonKey(name: "is_ad")
    bool? isAd;
    @JsonKey(name: "ad_transparent_content")
    dynamic adTransparentContent;
    @JsonKey(name: "show_ad_icon")
    bool? showAdIcon;
    @JsonKey(name: "status")
    bool? status;
    @JsonKey(name: "followers")
    int? followers;

    RecommendLiveItem({
        this.headBox,
        this.areaV2Id,
        this.areaV2ParentId,
        this.areaV2Name,
        this.areaV2ParentName,
        this.broadcastType,
        this.cover,
        this.link,
        this.online,
        this.pendantInfo,
        this.roomid,
        this.title,
        this.uname,
        this.face,
        this.verify,
        this.uid,
        this.keyframe,
        this.isAutoPlay,
        this.headBoxType,
        this.flag,
        this.sessionId,
        this.groupId,
        this.showCallback,
        this.clickCallback,
        this.specialId,
        this.watchedShow,
        this.isNft,
        this.nftDmark,
        this.isAd,
        this.adTransparentContent,
        this.showAdIcon,
        this.status,
        this.followers,
    });

    factory RecommendLiveItem.fromJson(Map<String, dynamic> json) => _$RecommendLiveItemFromJson(json);

    Map<String, dynamic> toJson() => _$RecommendLiveItemToJson(this);
}

@JsonSerializable()
class HeadBox {
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "value")
    String? value;
    @JsonKey(name: "desc")
    String? desc;

    HeadBox({
        this.name,
        this.value,
        this.desc,
    });

    factory HeadBox.fromJson(Map<String, dynamic> json) => _$HeadBoxFromJson(json);

    Map<String, dynamic> toJson() => _$HeadBoxToJson(this);
}

@JsonSerializable()
class PendantInfo {
    @JsonKey(name: "2")
    The2? the2;

    PendantInfo({
        this.the2,
    });

    factory PendantInfo.fromJson(Map<String, dynamic> json) => _$PendantInfoFromJson(json);

    Map<String, dynamic> toJson() => _$PendantInfoToJson(this);
}

@JsonSerializable()
class The2 {
    @JsonKey(name: "type")
    String? type;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "position")
    int? position;
    @JsonKey(name: "text")
    String? text;
    @JsonKey(name: "bg_color")
    String? bgColor;
    @JsonKey(name: "bg_pic")
    String? bgPic;
    @JsonKey(name: "pendant_id")
    int? pendantId;
    @JsonKey(name: "priority")
    int? priority;
    @JsonKey(name: "created_at")
    int? createdAt;

    The2({
        this.type,
        this.name,
        this.position,
        this.text,
        this.bgColor,
        this.bgPic,
        this.pendantId,
        this.priority,
        this.createdAt,
    });

    factory The2.fromJson(Map<String, dynamic> json) => _$The2FromJson(json);

    Map<String, dynamic> toJson() => _$The2ToJson(this);
}

@JsonSerializable()
class Verify {
    @JsonKey(name: "role")
    int? role;
    @JsonKey(name: "desc")
    String? desc;
    @JsonKey(name: "type")
    int? type;

    Verify({
        this.role,
        this.desc,
        this.type,
    });

    factory Verify.fromJson(Map<String, dynamic> json) => _$VerifyFromJson(json);

    Map<String, dynamic> toJson() => _$VerifyToJson(this);
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
    int? iconLocation;
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
