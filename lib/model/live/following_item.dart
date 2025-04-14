import 'package:json_annotation/json_annotation.dart';
part 'following_item.g.dart';
@JsonSerializable()
class FollowingLiveItems {
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "pageSize")
    int? pageSize;
    @JsonKey(name: "totalPage")
    int? totalPage;
    @JsonKey(name: "list")
    List<FollowingLiveItem>? list;
    @JsonKey(name: "count")
    int? count;
    @JsonKey(name: "never_lived_count")
    int? neverLivedCount;
    @JsonKey(name: "live_count")
    int? liveCount;
    @JsonKey(name: "never_lived_faces")
    List<dynamic>? neverLivedFaces;

    FollowingLiveItems({
        this.title,
        this.pageSize,
        this.totalPage,
        this.list,
        this.count,
        this.neverLivedCount,
        this.liveCount,
        this.neverLivedFaces,
    });

    factory FollowingLiveItems.fromJson(Map<String, dynamic> json) => _$FollowingLiveItemsFromJson(json);

    Map<String, dynamic> toJson() => _$FollowingLiveItemsToJson(this);
}

@JsonSerializable()
class FollowingLiveItem {
    @JsonKey(name: "roomid")
    int? roomid;
    @JsonKey(name: "uid")
    int? uid;
    @JsonKey(name: "uname")
    String? uname;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "face")
    String? face;
    @JsonKey(name: "live_status")
    int? liveStatus;
    @JsonKey(name: "record_num")
    int? recordNum;
    @JsonKey(name: "recent_record_id")
    String? recentRecordId;
    @JsonKey(name: "is_attention")
    int? isAttention;
    @JsonKey(name: "clipnum")
    int? clipnum;
    @JsonKey(name: "fans_num")
    int? fansNum;
    @JsonKey(name: "area_name")
    String? areaName;
    @JsonKey(name: "area_value")
    String? areaValue;
    @JsonKey(name: "tags")
    String? tags;
    @JsonKey(name: "recent_record_id_v2")
    String? recentRecordIdV2;
    @JsonKey(name: "record_num_v2")
    int? recordNumV2;
    @JsonKey(name: "record_live_time")
    int? recordLiveTime;
    @JsonKey(name: "area_name_v2")
    String? areaNameV2;
    @JsonKey(name: "room_news")
    String? roomNews;
    @JsonKey(name: "switch")
    bool? listSwitch;
    @JsonKey(name: "watch_icon")
    String? watchIcon;
    @JsonKey(name: "text_small")
    String? textSmall;
    @JsonKey(name: "room_cover")
    String? roomCover;
    @JsonKey(name: "parent_area_id")
    int? parentAreaId;
    @JsonKey(name: "area_id")
    int? areaId;

    FollowingLiveItem({
        this.roomid,
        this.uid,
        this.uname,
        this.title,
        this.face,
        this.liveStatus,
        this.recordNum,
        this.recentRecordId,
        this.isAttention,
        this.clipnum,
        this.fansNum,
        this.areaName,
        this.areaValue,
        this.tags,
        this.recentRecordIdV2,
        this.recordNumV2,
        this.recordLiveTime,
        this.areaNameV2,
        this.roomNews,
        this.listSwitch,
        this.watchIcon,
        this.textSmall,
        this.roomCover,
        this.parentAreaId,
        this.areaId,
    });

    factory FollowingLiveItem.fromJson(Map<String, dynamic> json) => _$FollowingLiveItemFromJson(json);

    Map<String, dynamic> toJson() => _$FollowingLiveItemToJson(this);
}
