import 'package:json_annotation/json_annotation.dart';
part 'hot_video.g.dart';

@JsonSerializable()
class HotVideoItemList {
  @JsonKey(name: "list")
  List<HotVideoItem>? list;
  @JsonKey(name: "no_more")
  bool? noMore;

  HotVideoItemList({
    this.list,
    this.noMore,
  });

  factory HotVideoItemList.fromJson(Map<String, dynamic> json) =>
      _$HotVideoItemListFromJson(json);

  Map<String, dynamic> toJson() => _$HotVideoItemListToJson(this);
}

@JsonSerializable()
class HotVideoItem {
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
  @JsonKey(name: "mission_id")
  int? missionId;
  @JsonKey(name: "rights")
  Map<String, int>? rights;
  @JsonKey(name: "owner")
  Owner? owner;
  @JsonKey(name: "stat")
  Stat? stat;
  @JsonKey(name: "dynamic")
  String? listDynamic;
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
  @JsonKey(name: "enable_vt")
  int? enableVt;
  @JsonKey(name: "ai_rcmd")
  dynamic aiRcmd;
  @JsonKey(name: "rcmd_reason")
  RcmdReason? rcmdReason;
  @JsonKey(name: "up_from_v2")
  int? upFromV2;

  HotVideoItem({
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
    this.missionId,
    this.rights,
    this.owner,
    this.stat,
    this.listDynamic,
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
    this.enableVt,
    this.aiRcmd,
    this.rcmdReason,
    this.upFromV2,
  });

  factory HotVideoItem.fromJson(Map<String, dynamic> json) =>
      _$HotVideoItemFromJson(json);

  Map<String, dynamic> toJson() => _$HotVideoItemToJson(this);
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

  factory Dimension.fromJson(Map<String, dynamic> json) =>
      _$DimensionFromJson(json);

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

@JsonSerializable()
class RcmdReason {
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "corner_mark")
  int? cornerMark;

  RcmdReason({
    this.content,
    this.cornerMark,
  });

  factory RcmdReason.fromJson(Map<String, dynamic> json) =>
      _$RcmdReasonFromJson(json);

  Map<String, dynamic> toJson() => _$RcmdReasonToJson(this);
}

@JsonSerializable()
class Stat {
  int? aid;
  int? view;
  int? danmaku;
  int? reply;
  int? favorite;
  int? coin;
  int? share;
  @JsonKey(name: "now_rank")
  int? nowRank;
  @JsonKey(name: "all_rank")
  int? hisRank;
  int? like;
  int? dislike;
  int? vt;
  int? vv;
  @JsonKey(name: "fav_g")
  int? favG;
  @JsonKey(name: "like_g")
  int? likeG;
  Stat({
    this.aid,
    this.view,
    this.danmaku,
    this.reply,
    this.favorite,
    this.coin,
    this.share,
    this.nowRank,
    this.hisRank,
    this.like,
    this.dislike,
    this.vt,
    this.vv,
    this.favG,
    this.likeG,
  });
  factory Stat.fromJson(Map<String, dynamic> json) => _$StatFromJson(json);

  Map<String, dynamic> toJson() => _$StatToJson(this);
}
