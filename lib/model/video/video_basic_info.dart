import 'dart:convert';

import 'package:dilidili/model/video/hot_video.dart';
import 'package:json_annotation/json_annotation.dart';
part 'video_basic_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoDetailData {
  String? bvid;
  int? aid;
  int? videos;
  int? tid;
  String? tname;
  int? copyright;
  String? pic;
  String? title;
  int? pubdate;
  int? ctime;
  String? desc;
  List<DescV2>? descV2;
  int? state;
  int? duration;
  Map<String, int>? rights;
  ArgueInfo? argueInfo;
  Owner? owner;
  Stat? stat;
  String? videoDynamic;
  int? cid;
  Dimension? dimension;
  dynamic premiere;
  int? teenageMode;
  bool? isChargeableSeason;
  bool? isStory;
  bool? noCache;
  List<Part>? pages;
  Subtitle? subtitle;
  // Label? label;
  UgcSeason? ugcSeason;
  bool? isSeasonDisplay;
  UserGarb? userGarb;
  HonorReply? honorReply;
  String? likeIcon;
  bool? needJumpBv;
  String? epId;
  List<Staff>? staff;

  VideoDetailData({
    this.bvid,
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
    this.descV2,
    this.state,
    this.duration,
    this.rights,
    this.owner,
    this.stat,
    this.argueInfo,
    this.videoDynamic,
    this.cid,
    this.dimension,
    this.premiere,
    this.teenageMode,
    this.isChargeableSeason,
    this.isStory,
    this.noCache,
    this.pages,
    this.subtitle,
    this.ugcSeason,
    this.isSeasonDisplay,
    this.userGarb,
    this.honorReply,
    this.likeIcon,
    this.needJumpBv,
    this.epId,
    this.staff,
  });
  factory VideoDetailData.fromJson(Map<String, dynamic> json) =>
      _$VideoDetailDataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDetailDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DescV2 {
  String? rawText;
  int? type;
  int? bizId;

  DescV2({
    this.rawText,
    this.type,
    this.bizId,
  });
  factory DescV2.fromJson(Map<String, dynamic> json) => _$DescV2FromJson(json);
  Map<String, dynamic> toJson() => _$DescV2ToJson(this);
}

@JsonSerializable()
class Dimension {
  int? width;
  int? height;
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

class Part {
  int? cid;
  int? page;
  String? from;
  String? pagePart;
  int? duration;
  String? vid;
  String? weblink;
  Dimension? dimension;
  String? firstFrame;
  String? cover;

  Part({
    this.cid,
    this.page,
    this.from,
    this.pagePart,
    this.duration,
    this.vid,
    this.weblink,
    this.dimension,
    this.firstFrame,
    this.cover,
  });

  fromRawJson(String str) => Part.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Part.fromJson(Map<String, dynamic> json) {
    cid = json["cid"];
    page = json["page"];
    from = json["from"];
    pagePart = json["part"];
    duration = json["duration"];
    vid = json["vid"];
    weblink = json["weblink"];
    dimension = json["dimension"] == null
        ? null
        : Dimension.fromJson(json["dimension"]);
    firstFrame = json["first_frame"] ?? '';
    cover = json["first_frame"] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cid"] = cid;
    data["page"] = page;
    data["from"] = from;
    data["part"] = pagePart;
    data["duration"] = duration;
    data["vid"] = vid;
    data["weblink"] = weblink;
    data["dimension"] = dimension?.toJson();
    data["first_frame"] = firstFrame;
    return data;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Subtitle {
  bool? allowSubmit;
  List<dynamic>? list;

  Subtitle({
    this.allowSubmit,
    this.list,
  });
  factory Subtitle.fromJson(Map<String, dynamic> json) =>
      _$SubtitleFromJson(json);
  Map<String, dynamic> toJson() => _$SubtitleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UgcSeason {
  UgcSeason({
    this.id,
    this.title,
    this.cover,
    this.mid,
    this.intro,
    this.signState,
    this.attribute,
    this.sections,
    this.stat,
    this.epCount,
    this.seasonType,
    this.isPaySeason,
  });

  int? id;
  String? title;
  String? cover;
  int? mid;
  String? intro;
  int? signState;
  int? attribute;
  List<SectionItem>? sections;
  Stat? stat;
  int? epCount;
  int? seasonType;
  bool? isPaySeason;
  factory UgcSeason.fromJson(Map<String, dynamic> json) =>
      _$UgcSeasonFromJson(json);
  Map<String, dynamic> toJson() => _$UgcSeasonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserGarb {
  String? urlImageAniCut;

  UserGarb({
    this.urlImageAniCut,
  });
  factory UserGarb.fromJson(Map<String, dynamic> json) =>
      _$UserGarbFromJson(json);
  Map<String, dynamic> toJson() => _$UserGarbToJson(this);
}

@JsonSerializable()
class HonorReply {
  List<Honor>? honor;

  HonorReply({
    this.honor,
  });
  factory HonorReply.fromJson(Map<String, dynamic> json) =>
      _$HonorReplyFromJson(json);
  Map<String, dynamic> toJson() => _$HonorReplyToJson(this);
}

@JsonSerializable()
class Staff {
  Staff({
    this.mid,
    this.title,
    this.name,
    this.face,
    this.vip,
  });

  int? mid;
  String? title;
  String? name;
  String? face;
  int? status;
  Vip? vip;
  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
  Map<String, dynamic> toJson() => _$StaffToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SectionItem {
  SectionItem({
    this.seasonId,
    this.id,
    this.title,
    this.type,
    this.episodes,
  });

  int? seasonId;
  int? id;
  String? title;
  int? type;
  List<EpisodeItem>? episodes;
  factory SectionItem.fromJson(Map<String, dynamic> json) =>
      _$SectionItemFromJson(json);
  Map<String, dynamic> toJson() => _$SectionItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Honor {
  int? aid;
  int? type;
  String? desc;
  int? weeklyRecommendNum;

  Honor({
    this.aid,
    this.type,
    this.desc,
    this.weeklyRecommendNum,
  });
  factory Honor.fromJson(Map<String, dynamic> json) => _$HonorFromJson(json);
  Map<String, dynamic> toJson() => _$HonorToJson(this);
}

@JsonSerializable()
class Vip {
  Vip({
    this.type,
    this.status,
  });

  int? type;
  int? status;
  factory Vip.fromJson(Map<String, dynamic> json) => _$VipFromJson(json);
  Map<String, dynamic> toJson() => _$VipToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class EpisodeItem {
  EpisodeItem({
    this.seasonId,
    this.sectionId,
    this.id,
    this.aid,
    this.cid,
    this.title,
    this.attribute,
    this.page,
    this.bvid,
    this.cover,
  });
  int? seasonId;
  int? sectionId;
  int? id;
  int? aid;
  int? cid;
  String? title;
  int? attribute;
  Part? page;
  String? bvid;
  String? cover;
  factory EpisodeItem.fromJson(Map<String, dynamic> json) =>
      _$EpisodeItemFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeItemToJson(this);
}

@JsonSerializable()
class ArgueInfo {
  String? argue_link;
  String? argue_msg;
  int? argue_type;
  ArgueInfo({
    this.argue_link,
    this.argue_msg,
    this.argue_type,
  });
  factory ArgueInfo.fromJson(Map<String, dynamic> json) =>
      _$ArgueInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ArgueInfoToJson(this);
}

@JsonSerializable()
class Owner {
  int mid;
  String name;
  String face;

  Owner({
    required this.mid,
    required this.name,
    required this.face,
  });
  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}
