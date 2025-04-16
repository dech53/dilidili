import 'package:json_annotation/json_annotation.dart';
part 'folder_detail.g.dart';
@JsonSerializable()
class FolderDetail {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "fid")
    int? fid;
    @JsonKey(name: "mid")
    int? mid;
    @JsonKey(name: "attr")
    int? attr;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "cover")
    String? cover;
    @JsonKey(name: "upper")
    Upper? upper;
    @JsonKey(name: "cover_type")
    int? coverType;
    @JsonKey(name: "cnt_info")
    CntInfo? cntInfo;
    @JsonKey(name: "type")
    int? type;
    @JsonKey(name: "intro")
    String? intro;
    @JsonKey(name: "ctime")
    int? ctime;
    @JsonKey(name: "mtime")
    int? mtime;
    @JsonKey(name: "state")
    int? state;
    @JsonKey(name: "fav_state")
    int? favState;
    @JsonKey(name: "like_state")
    int? likeState;
    @JsonKey(name: "media_count")
    int? mediaCount;
    @JsonKey(name: "is_top")
    bool? isTop;

    FolderDetail({
        this.id,
        this.fid,
        this.mid,
        this.attr,
        this.title,
        this.cover,
        this.upper,
        this.coverType,
        this.cntInfo,
        this.type,
        this.intro,
        this.ctime,
        this.mtime,
        this.state,
        this.favState,
        this.likeState,
        this.mediaCount,
        this.isTop,
    });

    factory FolderDetail.fromJson(Map<String, dynamic> json) => _$FolderDetailFromJson(json);

    Map<String, dynamic> toJson() => _$FolderDetailToJson(this);
}

@JsonSerializable()
class CntInfo {
    @JsonKey(name: "collect")
    int? collect;
    @JsonKey(name: "play")
    int? play;
    @JsonKey(name: "thumb_up")
    int? thumbUp;
    @JsonKey(name: "share")
    int? share;

    CntInfo({
        this.collect,
        this.play,
        this.thumbUp,
        this.share,
    });

    factory CntInfo.fromJson(Map<String, dynamic> json) => _$CntInfoFromJson(json);

    Map<String, dynamic> toJson() => _$CntInfoToJson(this);
}

@JsonSerializable()
class Upper {
    @JsonKey(name: "mid")
    int? mid;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "face")
    String? face;
    @JsonKey(name: "followed")
    bool? followed;
    @JsonKey(name: "vip_type")
    int? vipType;
    @JsonKey(name: "vip_statue")
    int? vipStatue;

    Upper({
        this.mid,
        this.name,
        this.face,
        this.followed,
        this.vipType,
        this.vipStatue,
    });

    factory Upper.fromJson(Map<String, dynamic> json) => _$UpperFromJson(json);

    Map<String, dynamic> toJson() => _$UpperToJson(this);
}
