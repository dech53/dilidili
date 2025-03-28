import 'package:json_annotation/json_annotation.dart';
part 'rcmd_video.g.dart';

@JsonSerializable()
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

  factory RcmdVideo.fromJson(Map<String, dynamic> json) =>
      _$RcmdVideoFromJson(json);
}

@JsonSerializable()
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

  factory VideoItem.fromJson(Map<String, dynamic> json) =>
      _$VideoItemFromJson(json);
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

@JsonSerializable()
class RcmdReason {
  int? reasonType;
  String? content;

  RcmdReason({
    this.reasonType,
    this.content,
  });

  factory RcmdReason.fromJson(Map<String, dynamic> json) =>
      _$RcmdReasonFromJson(json);
}

@JsonSerializable()
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

  factory Stat.fromJson(Map<String, dynamic> json) => _$StatFromJson(json);
}
