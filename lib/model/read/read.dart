import 'opus.dart';

class ReadDataModel {
  ReadDataModel({
    this.cvid,
    this.readInfo,
    this.readViewInfo,
    this.upInfo,
    this.catalogList,
    this.recommendInfoList,
    this.hiddenInteraction,
    this.isModern,
  });

  int? cvid;
  ReadInfo? readInfo;
  Map? readViewInfo;
  Map? upInfo;
  List<dynamic>? catalogList;
  List<dynamic>? recommendInfoList;
  bool? hiddenInteraction;
  bool? isModern;

  ReadDataModel.fromJson(Map<String, dynamic> json) {
    cvid = json['cvid'];
    readInfo =
        json['readInfo'] != null ? ReadInfo.fromJson(json['readInfo']) : null;
    readViewInfo = json['readViewInfo'];
    upInfo = json['upInfo'];
    if (json['catalogList'] != null) {
      catalogList = <dynamic>[];
      json['catalogList'].forEach((v) {
        catalogList!.add(v);
      });
    }
    if (json['recommendInfoList'] != null) {
      recommendInfoList = <dynamic>[];
      json['recommendInfoList'].forEach((v) {
        recommendInfoList!.add(v);
      });
    }
    hiddenInteraction = json['hiddenInteraction'];
    isModern = json['isModern'];
  }
}

class ReadInfo {
  ReadInfo({
    this.id,
    this.category,
    this.title,
    this.summary,
    this.bannerUrl,
    this.author,
    this.publishTime,
    this.ctime,
    this.mtime,
    this.stats,
    this.attributes,
    this.words,
    this.originImageUrls,
    this.content,
    this.opus,
    this.dynIdStr,
    this.totalArtNum,
  });

  int? id;
  Map? category;
  String? title;
  String? summary;
  String? bannerUrl;
  Author? author;
  int? publishTime;
  int? ctime;
  int? mtime;
  Map? stats;
  int? attributes;
  int? words;
  List<String>? originImageUrls;
  String? content;
  Opus? opus;
  String? dynIdStr;
  int? totalArtNum;

  ReadInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    summary = json['summary'];
    bannerUrl = json['banner_url'];
    author = Author.fromJson(json['author']);
    publishTime = json['publish_time'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    stats = json['stats'];
    attributes = json['attributes'];
    words = json['words'];
    if (json['origin_image_urls'] != null) {
      originImageUrls = <String>[];
      json['origin_image_urls'].forEach((v) {
        originImageUrls!.add(v);
      });
    }
    content = json['content'];
    opus = json['opus'] != null ? Opus.fromJson(json['opus']) : null;
    dynIdStr = json['dyn_id_str'];
    totalArtNum = json['total_art_num'];
  }
}

class Author {
  Author({
    this.mid,
    this.name,
    this.face,
    this.vip,
    this.fans,
    this.level,
  });

  int? mid;
  String? name;
  String? face;
  Vip? vip;
  int? fans;
  int? level;

  Author.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'];
    face = json['face'];
    vip = json['vip'] != null ? Vip.fromJson(json['vip']) : null;
    fans = json['fans'];
    level = json['level'];
  }
}

class Opus {
  Opus({
    this.opusId,
    this.opusSource,
    this.title,
    this.content,
  });

  int? opusId;
  int? opusSource;
  String? title;
  Content? content;

  Opus.fromJson(Map<String, dynamic> json) {
    opusId = json['opus_id'];
    opusSource = json['opus_source'];
    title = json['title'];
    content =
        json['content'] != null ? Content.fromJson(json['content']) : null;
  }
}

class Content {
  Content({
    this.paragraphs,
  });

  List<ModuleParagraph>? paragraphs;

  Content.fromJson(Map<String, dynamic> json) {
    if (json['paragraphs'] != null) {
      paragraphs = <ModuleParagraph>[];
      json['paragraphs'].forEach((v) {
        paragraphs!.add(ModuleParagraph.fromJson(v));
      });
    }
  }
}

class Vip {
  Vip({
    this.type,
    this.status,
    this.dueDate,
    this.label,
    this.nicknameColor,
  });

  int? type;
  int? status;
  int? dueDate;
  Map? label;
  int? nicknameColor;

  Vip.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
    dueDate = json['due_date'];
    label = json['label'];
    nicknameColor = json['nickname_color'] == ''
        ? null
        : int.parse("0xFF${json['nickname_color'].replaceAll('#', '')}");
  }
}
