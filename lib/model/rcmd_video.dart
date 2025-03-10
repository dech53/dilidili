class RcmdVideo {
  List<VideoItem> item;
  dynamic business_card;
  dynamic floor_info;
  dynamic user_feature;
  int preload_expose_pct;
  int preload_floor_expose_pct;
  int mid;

  RcmdVideo({
    required this.item,
    this.business_card,
    this.floor_info,
    this.user_feature,
    required this.preload_expose_pct,
    required this.preload_floor_expose_pct,
    required this.mid,
  });

  factory RcmdVideo.fromJson(Map<String, dynamic> json) {
    return RcmdVideo(
      item: json["item"] != null
          ? List<VideoItem>.from(json["item"].map((x) => VideoItem.fromJson(x)))
          : [],
      business_card: json["business_card"] ?? null,
      floor_info: json["floor_info"] ?? null,
      user_feature: json["user_feature"] ?? null,
      preload_expose_pct: json["preload_expose_pct"] ?? 0,
      preload_floor_expose_pct: json["preload_floor_expose_pct"] ?? 0,
      mid: json["mid"] ?? 0,
    );
  }
}

class VideoItem {
  int id;
  String bvid;
  int cid;
  String goto;
  String uri;
  String pic;
  String pic_4_3;
  String title;
  int duration;
  int pubdate;
  Owner owner;
  Stat stat;
  dynamic av_feature;
  int is_followed;
  RcmdReason? rcmd_reason;
  int show_info;
  String track_id;
  int pos;
  dynamic room_info;
  dynamic ogv_info;
  dynamic business_info;
  int is_stock;
  int enable_vt;
  String vt_display;
  int dislike_switch;
  int dislike_switch_pc;

  VideoItem({
    required this.id,
    required this.bvid,
    required this.cid,
    required this.goto,
    required this.uri,
    required this.pic,
    required this.pic_4_3,
    required this.title,
    required this.duration,
    required this.pubdate,
    required this.owner,
    required this.stat,
    this.av_feature,
    required this.is_followed,
    this.rcmd_reason,
    required this.show_info,
    required this.track_id,
    required this.pos,
    this.room_info,
    this.ogv_info,
    this.business_info,
    required this.is_stock,
    required this.enable_vt,
    required this.vt_display,
    required this.dislike_switch,
    required this.dislike_switch_pc,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json["id"] ?? 0,
      bvid: json["bvid"] ?? "",
      cid: json["cid"] ?? 0,
      goto: json["goto"] ?? "",
      uri: json["uri"] ?? "",
      pic: json["pic"] ?? "",
      pic_4_3: json["pic_4_3"] ?? "",
      title: json["title"] ?? "",
      duration: json["duration"] ?? 0,
      pubdate: json["pubdate"] ?? 0,
      owner: json["owner"] != null
          ? Owner.fromJson(json["owner"])
          : Owner(mid: 0, name: "", face: ""),
      stat: json["stat"] != null
          ? Stat.fromJson(json["stat"])
          : Stat(view: 0, like: 0, danmaku: 0, vt: 0),
      av_feature: json["av_feature"] ?? null,
      is_followed: json["is_followed"] ?? 0,
      rcmd_reason: json["rcmd_reason"] != null
          ? RcmdReason.fromJson(json["rcmd_reason"])
          : null,
      show_info: json["show_info"] ?? 0,
      track_id: json["track_id"] ?? "",
      pos: json["pos"] ?? 0,
      room_info: json["room_info"] ?? null,
      ogv_info: json["ogv_info"] ?? null,
      business_info: json["business_info"] ?? null,
      is_stock: json["is_stock"] ?? 0,
      enable_vt: json["enable_vt"] ?? 0,
      vt_display: json["vt_display"] ?? "",
      dislike_switch: json["dislike_switch"] ?? 0,
      dislike_switch_pc: json["dislike_switch_pc"] ?? 0,
    );
  }
}

class Owner {
  int mid;
  String name;
  String face;

  Owner({
    required this.mid,
    required this.name,
    required this.face,
  });
  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        mid: json["mid"],
        name: json["name"],
        face: json["face"],
      );
}

class RcmdReason {
  int? reasonType;
  String? content;

  RcmdReason({
    this.reasonType,
    this.content,
  });

  factory RcmdReason.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RcmdReason();
    return RcmdReason(
      reasonType: json["reason_type"] ?? null,
      content: json["content"] ?? null,
    );
  }
}

class Stat {
  int view;
  int like;
  int danmaku;
  int vt;

  Stat({
    required this.view,
    required this.like,
    required this.danmaku,
    required this.vt,
  });

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        view: json["view"],
        like: json["like"],
        danmaku: json["danmaku"],
        vt: json["vt"],
      );
}
