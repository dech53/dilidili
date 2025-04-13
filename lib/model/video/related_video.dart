import 'package:dilidili/model/video/hot_video.dart';
import 'package:json_annotation/json_annotation.dart';
part 'related_video.g.dart';
@JsonSerializable()
class RelatedVideoItem {
    @JsonKey(name: "aid")
    int? aid;
    @JsonKey(name: "videos")
    int? videos;
    @JsonKey(name: "tid")
    int? tid;
    @JsonKey(name: "tname")
    String? tname;
    @JsonKey(name: "copyright")
    int? copyright;
    @JsonKey(name: "pic")
    String? pic;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "pubdate")
    int? pubdate;
    @JsonKey(name: "ctime")
    int? ctime;
    @JsonKey(name: "desc")
    String? desc;
    @JsonKey(name: "state")
    int? state;
    @JsonKey(name: "duration")
    int? duration;
    @JsonKey(name: "rights")
    Map<String, int>? rights;
    @JsonKey(name: "owner")
    Owner? owner;
    @JsonKey(name: "stat")
    Stat? stat;
    @JsonKey(name: "dynamic")
    String? relatedVideoItemDynamic;
    @JsonKey(name: "cid")
    int? cid;
    @JsonKey(name: "dimension")
    Dimension? dimension;
    @JsonKey(name: "season_id")
    int? seasonId;
    @JsonKey(name: "short_link_v2")
    String? shortLinkV2;
    @JsonKey(name: "first_frame")
    String? firstFrame;
    @JsonKey(name: "pub_location")
    String? pubLocation;
    @JsonKey(name: "cover43")
    String? cover43;
    @JsonKey(name: "tidv2")
    int? tidv2;
    @JsonKey(name: "tnamev2")
    String? tnamev2;
    @JsonKey(name: "pid_v2")
    int? pidV2;
    @JsonKey(name: "pid_name_v2")
    String? pidNameV2;
    @JsonKey(name: "bvid")
    String? bvid;
    @JsonKey(name: "season_type")
    int? seasonType;
    @JsonKey(name: "is_ogv")
    bool? isOgv;
    @JsonKey(name: "ogv_info")
    dynamic ogvInfo;
    @JsonKey(name: "rcmd_reason")
    String? rcmdReason;
    @JsonKey(name: "enable_vt")
    int? enableVt;
    @JsonKey(name: "ai_rcmd")
    AiRcmd? aiRcmd;

    RelatedVideoItem({
        this.aid,
        this.videos,
        this.tid,
        this.tname,
        this.copyright,
        this.pic,
        this.title,
        this.pubdate,
        this.ctime,
        this.desc,
        this.state,
        this.duration,
        this.rights,
        this.owner,
        this.stat,
        this.relatedVideoItemDynamic,
        this.cid,
        this.dimension,
        this.seasonId,
        this.shortLinkV2,
        this.firstFrame,
        this.pubLocation,
        this.cover43,
        this.tidv2,
        this.tnamev2,
        this.pidV2,
        this.pidNameV2,
        this.bvid,
        this.seasonType,
        this.isOgv,
        this.ogvInfo,
        this.rcmdReason,
        this.enableVt,
        this.aiRcmd,
    });

    factory RelatedVideoItem.fromJson(Map<String, dynamic> json) => _$RelatedVideoItemFromJson(json);

    Map<String, dynamic> toJson() => _$RelatedVideoItemToJson(this);
}

@JsonSerializable()
class AiRcmd {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "goto")
    String? goto;
    @JsonKey(name: "trackid")
    String? trackid;
    @JsonKey(name: "uniq_id")
    String? uniqId;

    AiRcmd({
        this.id,
        this.goto,
        this.trackid,
        this.uniqId,
    });

    factory AiRcmd.fromJson(Map<String, dynamic> json) => _$AiRcmdFromJson(json);

    Map<String, dynamic> toJson() => _$AiRcmdToJson(this);
}

@JsonSerializable()
class Dimension {
    @JsonKey(name: "width")
    int? width;
    @JsonKey(name: "height")
    int? height;
    @JsonKey(name: "rotate")
    int? rotate;

    Dimension({
        this.width,
        this.height,
        this.rotate,
    });

    factory Dimension.fromJson(Map<String, dynamic> json) => _$DimensionFromJson(json);

    Map<String, dynamic> toJson() => _$DimensionToJson(this);
}

@JsonSerializable()
class Owner {
    @JsonKey(name: "mid")
    int? mid;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "face")
    String? face;

    Owner({
        this.mid,
        this.name,
        this.face,
    });

    factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

    Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
