import 'dart:convert';

int? asInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

class MomentsDataModel {
  MomentsDataModel({
    this.hasMore,
    this.items,
    this.offset,
    this.total,
    this.loadNext,
  });
  bool? hasMore;
  List<MomentItemModel>? items;
  String? offset;
  int? total;
  bool? loadNext;

  MomentsDataModel.fromJson(Map<String, dynamic> json) {
    hasMore = json['has_more'];
    items = (json['items'] as List?)
        ?.map<MomentItemModel>((e) => MomentItemModel.fromJson(e))
        .toList();
    offset = json['offset'];
    total = asInt(json['total']);
  }
}

// 单个动态
class MomentItemModel {
  MomentItemModel({
    this.basic,
    this.idStr,
    this.modules,
    this.orig,
    this.type,
    this.visible,
  });

  Map? basic;
  Basic? basicInfo;
  String? idStr;
  ItemModulesModel? modules;
  ItemOrigModel? orig;
  String? type;
  bool? visible;
  Fallback? fallback;

  MomentItemModel.fromJson(Map<String, dynamic> json) {
    basic = json['basic'];
    basicInfo = json['basic'] != null ? Basic.fromJson(json['basic']) : null;
    idStr = json['id_str']?.toString();
    modules = json['modules'] != null
        ? ItemModulesModel.fromJson(json['modules'])
        : null;
    orig = json['orig'] != null ? ItemOrigModel.fromJson(json['orig']) : null;
    type = json['type'];
    visible = json['visible'];
    fallback =
        json['fallback'] != null ? Fallback.fromJson(json['fallback']) : null;
  }

  bool get hasNoPrivilegeDynamic =>
      (basicInfo?.isOnlyFans ?? false) &&
      modules?.moduleDynamic?.major?.type == 'MAJOR_TYPE_BLOCKED' &&
      modules?.moduleDynamic?.major?.blocked != null;

  bool get hasOnlyFansVideoBadge =>
      (basicInfo?.isOnlyFans ?? false) &&
      type == 'DYNAMIC_TYPE_AV' &&
      modules?.moduleDynamic?.major?.archive?.badge?['text'] == '充电专属';
}

class ItemOrigModel {
  ItemOrigModel({
    this.basic,
    this.idStr,
    this.modules,
    this.type,
    this.visible,
  });

  Map? basic;
  Basic? basicInfo;
  String? idStr;
  ItemModulesModel? modules;
  String? type;
  bool? visible;
  Fallback? fallback;

  ItemOrigModel.fromJson(Map<String, dynamic> json) {
    basic = json['basic'];
    basicInfo = json['basic'] != null ? Basic.fromJson(json['basic']) : null;
    idStr = json['id_str']?.toString();
    modules = json['modules'] != null
        ? ItemModulesModel.fromJson(json['modules'])
        : null;
    type = json['type'];
    visible = json['visible'];
    fallback =
        json['fallback'] != null ? Fallback.fromJson(json['fallback']) : null;
  }

  bool get hasNoPrivilegeDynamic =>
      (basicInfo?.isOnlyFans ?? false) &&
      modules?.moduleDynamic?.major?.type == 'MAJOR_TYPE_BLOCKED' &&
      modules?.moduleDynamic?.major?.blocked != null;

  bool get hasOnlyFansVideoBadge =>
      (basicInfo?.isOnlyFans ?? false) &&
      type == 'DYNAMIC_TYPE_AV' &&
      modules?.moduleDynamic?.major?.archive?.badge?['text'] == '充电专属';
}

class Fallback {
  Fallback({this.id});

  String? id;

  Fallback.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
  }
}

// 单个动态详情
class ItemModulesModel {
  ItemModulesModel({
    this.moduleAuthor,
    this.moduleDynamic,
    // this.moduleInter,
    this.moduleStat,
    this.moduleTag,
    this.moduleInteraction,
    this.moduleDispute,
    this.moduleFold,
    this.moduleTop,
    this.moduleCollection,
    this.moduleExtend,
    this.moduleContent,
    this.moduleBlocked,
  });

  ModuleAuthorModel? moduleAuthor;
  ModuleDynamicModel? moduleDynamic;
  // ModuleInterModel? moduleInter;
  ModuleStatModel? moduleStat;
  ModuleTag? moduleTag;
  ModuleInteraction? moduleInteraction;
  ModuleDispute? moduleDispute;
  ModuleFold? moduleFold;
  ModuleTop? moduleTop;
  ModuleCollection? moduleCollection;
  List<ModuleTag>? moduleExtend;
  List<ArticleContentModel>? moduleContent;
  ModuleBlocked? moduleBlocked;

  ItemModulesModel.fromJson(Map<String, dynamic> json) {
    moduleAuthor = json['module_author'] != null
        ? ModuleAuthorModel.fromJson(json['module_author'])
        : null;
    moduleDynamic = json['module_dynamic'] != null
        ? ModuleDynamicModel.fromJson(json['module_dynamic'])
        : null;
    // moduleInter = ModuleInterModel.fromJson(json['module_interaction']);
    moduleStat = json['module_stat'] != null
        ? ModuleStatModel.fromJson(json['module_stat'])
        : null;
    moduleTag = json['module_tag'] != null
        ? ModuleTag.fromJson(json['module_tag'])
        : null;
    moduleInteraction = json['module_interaction'] != null
        ? ModuleInteraction.fromJson(json['module_interaction'])
        : null;
    moduleDispute = json['module_dispute'] != null
        ? ModuleDispute.fromJson(json['module_dispute'])
        : null;
    moduleFold = json['module_fold'] != null
        ? ModuleFold.fromJson(json['module_fold'])
        : null;
    moduleBlocked = json['module_blocked'] != null
        ? ModuleBlocked.fromJson(json['module_blocked'])
        : null;
  }

  ItemModulesModel.fromOpusJson(List json) {
    for (final item in json) {
      if (item is! Map<String, dynamic>) continue;
      switch (item['module_type']) {
        case 'MODULE_TYPE_TOP':
          moduleTop = item['module_top'] == null
              ? null
              : ModuleTop.fromJson(item['module_top']);
          break;
        case 'MODULE_TYPE_TITLE':
          moduleTag = item['module_title'] == null
              ? null
              : ModuleTag.fromJson(item['module_title']);
          break;
        case 'MODULE_TYPE_COLLECTION':
          moduleCollection = item['module_collection'] == null
              ? null
              : ModuleCollection.fromJson(item['module_collection']);
          break;
        case 'MODULE_TYPE_AUTHOR':
          moduleAuthor = item['module_author'] == null
              ? null
              : ModuleAuthorModel.fromJson(item['module_author']);
          break;
        case 'MODULE_TYPE_CONTENT':
          moduleContent = (item['module_content']?['paragraphs'] as List?)
              ?.map((e) => ArticleContentModel.fromJson(e))
              .toList();
          break;
        case 'MODULE_TYPE_BLOCKED':
          moduleBlocked = item['module_blocked'] == null
              ? null
              : ModuleBlocked.fromJson(item['module_blocked']);
          break;
        case 'MODULE_TYPE_EXTEND':
          moduleExtend = (item['module_extend']?['items'] as List?)
              ?.map((e) => ModuleTag.fromJson(e))
              .toList();
          break;
        case 'MODULE_TYPE_STAT':
          moduleStat = item['module_stat'] == null
              ? null
              : ModuleStatModel.fromJson(item['module_stat']);
          break;
      }
    }
  }
}

class ModuleDispute {
  String? title;
  String? desc;
  String? jumpUrl;

  ModuleDispute.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    jumpUrl = json['jump_url'];
  }
}

class ModuleInteraction {
  List<ModuleInteractionItem>? items;

  ModuleInteraction.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List?)
        ?.map((e) => ModuleInteractionItem.fromJson(e))
        .toList();
  }
}

class ModuleInteractionItem {
  int? type;
  DynamicDescModel? desc;

  ModuleInteractionItem.fromJson(Map<String, dynamic> json) {
    type = asInt(json['type']);
    desc =
        json['desc'] == null ? null : DynamicDescModel.fromJson(json['desc']);
  }
}

class ModuleFold {
  List<String>? ids;
  String? statement;
  List<DynamicOwner>? users;

  ModuleFold.fromJson(Map<String, dynamic> json) {
    ids = (json['ids'] as List?)?.map((e) => e.toString()).toList();
    statement = json['statement'];
    users =
        (json['users'] as List?)?.map((e) => DynamicOwner.fromJson(e)).toList();
  }
}

class DynamicOwner {
  int? mid;
  String? name;
  String? face;

  DynamicOwner.fromJson(Map<String, dynamic> json) {
    mid = asInt(json['mid']);
    name = json['name'];
    face = json['face'];
  }
}

class ModuleCollection {
  String? count;
  int? id;
  String? name;
  String? title;

  ModuleCollection.fromJson(Map<String, dynamic> json) {
    count = json['count']?.toString();
    id = asInt(json['id']);
    name = json['name'];
    title = json['title'];
  }
}

class ModuleTop {
  ModuleTopDisplay? display;

  ModuleTop.fromJson(Map<String, dynamic> json) {
    display = json['display'] == null
        ? null
        : ModuleTopDisplay.fromJson(json['display']);
  }
}

class ModuleTopDisplay {
  ModuleTopAlbum? album;

  ModuleTopDisplay.fromJson(Map<String, dynamic> json) {
    album =
        json['album'] == null ? null : ModuleTopAlbum.fromJson(json['album']);
  }
}

class ModuleTopAlbum {
  List<DynamicDrawItemModel>? pics;

  ModuleTopAlbum.fromJson(Map<String, dynamic> json) {
    pics = (json['pics'] as List?)
        ?.map((e) => DynamicDrawItemModel.fromJson(e))
        .toList();
  }
}

class ModuleBlocked {
  BgImg? bgImg;
  int? blockedType;
  Button? button;
  String? title;
  String? hintMessage;
  BgImg? icon;

  ModuleBlocked.fromJson(Map<String, dynamic> json) {
    bgImg = json['bg_img'] == null ? null : BgImg.fromJson(json['bg_img']);
    blockedType = asInt(json['blocked_type']);
    button = json['button'] == null ? null : Button.fromJson(json['button']);
    title = json['title'];
    hintMessage = json['hint_message'];
    icon = json['icon'] == null ? null : BgImg.fromJson(json['icon']);
  }
}

class Button {
  String? icon;
  String? jumpUrl;
  String? text;
  JumpStyle? jumpStyle;
  Check? check;

  Button.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    jumpUrl = json['jump_url'];
    text = json['text'];
    jumpStyle = json['jump_style'] == null
        ? null
        : JumpStyle.fromJson(json['jump_style']);
    check = json['check'] == null ? null : Check.fromJson(json['check']);
  }
}

class Check {
  String? text;

  Check.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }
}

class BgImg {
  String? imgDark;
  String? imgDay;

  BgImg.fromJson(Map<String, dynamic> json) {
    imgDark = json['img_dark'];
    imgDay = json['img_day'];
  }
}

class Basic {
  String? commentIdStr;
  int? commentType;
  String? ridStr;
  bool? isOnlyFans;
  String? title;
  int? uid;

  Basic.fromJson(Map<String, dynamic> json) {
    commentIdStr = json['comment_id_str'];
    commentType = asInt(json['comment_type']);
    ridStr = json['rid_str'];
    isOnlyFans = json['is_only_fans'] == true || json['isOnlyFans'] == true;
    title = json['title'];
    uid = asInt(json['uid']);
  }
}

// 单个动态详情 - 作者信息
class ModuleAuthorModel {
  ModuleAuthorModel({
    this.avatar,
    this.decorate,
    this.face,
    this.following,
    this.jumpUrl,
    this.label,
    this.mid,
    this.name,
    this.officialVerify,
    this.pendant,
    this.pubAction,
    this.pubLocationText,
    this.pubTime,
    this.pubTs,
    this.type,
    this.vip,
    this.isTop,
    this.badgeText,
  });

  Map? avatar;
  Decorate? decorate;
  String? face;
  bool? following;
  String? jumpUrl;
  String? label;
  int? mid;
  String? name;
  Map? officialVerify;
  Map? pendant;
  String? pubAction;
  String? pubLocationText;
  String? pubTime;
  int? pubTs;
  String? type;
  Map? vip;
  bool? isTop;
  String? badgeText;

  ModuleAuthorModel.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    decorate =
        json['decorate'] != null ? Decorate.fromJson(json['decorate']) : null;
    face = json['face'];
    following = json['following'] == true || json['following'] == 1;
    jumpUrl = json['jump_url'];
    label = json['label'];
    mid = asInt(json['mid']);
    name = json['name'];
    officialVerify = json['official_verify'] ?? json['official'];
    pendant = json['pendant'];
    pubAction = json['pub_action'];
    pubLocationText = json['pub_location_text'];
    pubTime = json['pub_time'];
    final parsedPubTs = asInt(json['pub_ts']);
    pubTs = parsedPubTs == null || parsedPubTs == 0 ? null : parsedPubTs;
    type = json['type'];
    vip = json['vip'];
    isTop = json['is_top'];
    badgeText = json['icon_badge']?['text'];
  }
}

class Decorate {
  Decorate({
    this.cardUrl,
    this.fan,
  });

  String? cardUrl;
  Fan? fan;

  Decorate.fromJson(Map<String, dynamic> json) {
    cardUrl = json['card_url'];
    fan = json['fan'] == null ? null : Fan.fromJson(json['fan']);
  }
}

class Fan {
  Fan({
    this.color,
    this.numStr,
  });

  String? color;
  String? numStr;

  Fan.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    numStr = json['num_str'];
  }
}

// 单个动态详情 - 动态信息
class ModuleDynamicModel {
  ModuleDynamicModel({
    this.additional,
    this.desc,
    this.major,
    this.topic,
  });

  DynamicAddModel? additional;
  DynamicDescModel? desc;
  DynamicMajorModel? major;
  DynamicTopicModel? topic;

  ModuleDynamicModel.fromJson(Map<String, dynamic> json) {
    additional = json['additional'] != null
        ? DynamicAddModel.fromJson(json['additional'])
        : null;
    desc =
        json['desc'] != null ? DynamicDescModel.fromJson(json['desc']) : null;
    if (json['major'] != null) {
      major = DynamicMajorModel.fromJson(json['major']);
    }
    topic = json['topic'] != null
        ? DynamicTopicModel.fromJson(json['topic'])
        : null;
  }
}

// 单个动态详情 - 评论？信息
// class ModuleInterModel {
//   ModuleInterModel({

//   });

//   ModuleInterModel.fromJson(Map<String, dynamic> json) {

//   }
// }
class DynamicAddModel {
  DynamicAddModel({
    this.type,
    this.vote,
    this.ugc,
    this.reserve,
    this.goods,
  });

  String? type;
  Vote? vote;
  Ugc? ugc;
  Reserve? reserve;
  Good? goods;
  UpowerLottery? upowerLottery;
  AddMatch? match;
  AddCommon? common;

  DynamicAddModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    vote = json['vote'] != null ? Vote.fromJson(json['vote']) : null;
    ugc = json['ugc'] != null ? Ugc.fromJson(json['ugc']) : null;
    reserve =
        json['reserve'] != null ? Reserve.fromJson(json['reserve']) : null;
    goods = json['goods'] != null ? Good.fromJson(json['goods']) : null;
    upowerLottery = json['upower_lottery'] != null
        ? UpowerLottery.fromJson(json['upower_lottery'])
        : null;
    match = json['match'] != null ? AddMatch.fromJson(json['match']) : null;
    common = json['common'] != null ? AddCommon.fromJson(json['common']) : null;
  }
}

class AddMatch {
  AddMatch({
    this.button,
    this.jumpUrl,
    this.matchInfo,
  });

  Button? button;
  String? jumpUrl;
  MatchInfo? matchInfo;

  AddMatch.fromJson(Map<String, dynamic> json) {
    button = json['button'] == null ? null : Button.fromJson(json['button']);
    jumpUrl = json['jump_url'];
    matchInfo = json['match_info'] == null
        ? null
        : MatchInfo.fromJson(json['match_info']);
  }
}

class MatchInfo {
  MatchInfo({
    this.centerBottom,
    this.centerTop,
    this.leftTeam,
    this.rightTeam,
    this.subTitle,
    this.title,
  });

  String? centerBottom;
  List? centerTop;
  TTeam? leftTeam;
  TTeam? rightTeam;
  dynamic subTitle;
  String? title;

  MatchInfo.fromJson(Map<String, dynamic> json) {
    centerBottom = json['center_bottom'];
    centerTop = json['center_top'];
    leftTeam =
        json['left_team'] == null ? null : TTeam.fromJson(json['left_team']);
    rightTeam =
        json['right_team'] == null ? null : TTeam.fromJson(json['right_team']);
    subTitle = json['sub_title'];
    title = json['title'];
  }
}

class TTeam {
  TTeam({
    this.name,
    this.pic,
  });

  String? name;
  String? pic;

  TTeam.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pic = json['pic'];
  }
}

class AddCommon {
  AddCommon({
    this.button,
    this.cover,
    this.desc1,
    this.desc2,
    this.jumpUrl,
    this.title,
  });

  Button? button;
  String? cover;
  String? desc1;
  String? desc2;
  String? jumpUrl;
  String? title;

  AddCommon.fromJson(Map<String, dynamic> json) {
    button = json['button'] == null ? null : Button.fromJson(json['button']);
    cover = json['cover'];
    desc1 = json['desc1'];
    desc2 = json['desc2'];
    jumpUrl = json['jump_url'];
    title = json['title'];
  }
}

class UpowerLottery {
  UpowerLottery({
    this.button,
    this.desc,
    this.hint,
    this.jumpUrl,
    this.title,
  });

  Button? button;
  Desc? desc;
  Hint? hint;
  String? jumpUrl;
  String? title;

  UpowerLottery.fromJson(Map<String, dynamic> json) {
    button = json['button'] == null ? null : Button.fromJson(json['button']);
    desc = json['desc'] == null ? null : Desc.fromJson(json['desc']);
    hint = json['hint'] == null ? null : Hint.fromJson(json['hint']);
    jumpUrl = json['jump_url'];
    title = json['title'];
  }
}

class Hint {
  Hint({this.text});

  String? text;

  Hint.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }
}

class JumpStyle {
  JumpStyle({this.text});

  String? text;

  JumpStyle.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }
}

class Vote {
  Vote({
    this.choiceCnt,
    this.defaultShare,
    this.share,
    this.endTime,
    this.joinNum,
    this.status,
    this.type,
    this.uid,
    this.voteId,
    this.title,
  });

  int? choiceCnt;
  String? share;
  int? defaultShare;
  int? endTime;
  int? joinNum;
  int? status;
  int? type;
  int? uid;
  int? voteId;
  String? title;

  Vote.fromJson(Map<String, dynamic> json) {
    choiceCnt = asInt(json['choice_cnt']);
    share = json['share'];
    defaultShare = asInt(json['default_share']);
    endTime = asInt(json['end_time']);
    joinNum = asInt(json['join_num']);
    status = asInt(json['status']);
    type = asInt(json['type']);
    uid = asInt(json['uid']);
    voteId = asInt(json['vote_id']);
    title = json['title'] ?? json['desc'];
  }
}

class Ugc {
  Ugc({
    this.cover,
    this.descSecond,
    this.duration,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.multiLine,
    this.title,
  });

  String? cover;
  String? descSecond;
  String? duration;
  String? headText;
  String? idStr;
  String? jumpUrl;
  bool? multiLine;
  String? title;

  Ugc.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    descSecond = json['desc_second'];
    duration = json['duration'];
    headText = json['head_text'];
    idStr = json['id_str'];
    jumpUrl = json['jump_url'];
    multiLine = json['multi_line'];
    title = json['title'];
  }
}

class Reserve {
  Reserve({
    this.button,
    this.desc1,
    this.desc2,
    this.desc3,
    this.jumpUrl,
    this.reserveTotal,
    this.rid,
    this.state,
    this.stype,
    this.title,
    this.upMid,
  });

  Map? button;
  Map? desc1;
  Map? desc2;
  Map? desc3;
  ReserveBtn? buttonInfo;
  Desc? desc1Info;
  Desc? desc2Info;
  Desc? desc3Info;
  String? jumpUrl;
  int? reserveTotal;
  int? rid;
  int? state;
  int? stype;
  String? title;
  int? upMid;

  Reserve.fromJson(Map<String, dynamic> json) {
    button = json['button'];
    desc1 = json['desc1'];
    desc2 = json['desc2'];
    desc3 = json['desc3'];
    buttonInfo =
        json['button'] == null ? null : ReserveBtn.fromJson(json['button']);
    desc1Info = json['desc1'] == null ? null : Desc.fromJson(json['desc1']);
    desc2Info = json['desc2'] == null ? null : Desc.fromJson(json['desc2']);
    desc3Info = json['desc3'] == null ? null : Desc.fromJson(json['desc3']);
    jumpUrl = json['jump_url'];
    reserveTotal = asInt(json['reserve_total']);
    rid = asInt(json['rid']);
    state = asInt(json['state']);
    stype = asInt(json['stype']);
    title = json['title'];
    upMid = asInt(json['up_mid']);
  }
}

class ReserveBtn {
  ReserveBtn({
    this.status,
    this.type,
    this.checkText,
    this.uncheckText,
  });

  int? status;
  int? type;
  String? checkText;
  String? uncheckText;
  int? disable;
  String? jumpText;
  String? jumpUrl;

  ReserveBtn.fromJson(Map<String, dynamic> json) {
    status = asInt(json['status']);
    type = asInt(json['type']);
    checkText = json['check']?['text'] ?? '已预约';
    uncheckText = json['uncheck']?['text'] ?? '预约';
    disable = asInt(json['uncheck']?['disable']);
    jumpText = json['jump_style']?['text'];
    jumpUrl = json['jump_url'];
  }
}

class Desc {
  Desc({
    this.text,
    this.jumpUrl,
  });

  String? text;
  String? jumpUrl;

  Desc.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    jumpUrl = json['jump_url'];
  }
}

class Good {
  Good({
    this.headIcon,
    this.headText,
    this.items,
    this.jumpUrl,
  });

  String? headIcon;
  String? headText;
  List<GoodItem>? items;
  String? jumpUrl;

  Good.fromJson(Map<String, dynamic> json) {
    headIcon = json['head_icon'];
    headText = json['head_text'];
    items = (json['items'] as List?)
        ?.map<GoodItem>((e) => GoodItem.fromJson(e))
        .toList();
    jumpUrl = json['jump_url'];
  }
}

class GoodItem {
  GoodItem({
    this.brief,
    this.cover,
    this.id,
    this.jumpDesc,
    this.jumpUrl,
    this.name,
    this.price,
  });

  String? brief;
  String? cover;
  dynamic id;
  String? jumpDesc;
  String? jumpUrl;
  String? name;
  String? price;

  GoodItem.fromJson(Map<String, dynamic> json) {
    brief = json['brief'];
    cover = json['cover'];
    id = json['id'];
    jumpDesc = json['jump_desc'];
    jumpUrl = json['jump_url'];
    name = json['name'];
    price = json['price'];
  }
}

class DynamicDescModel {
  DynamicDescModel({
    this.richTextNodes,
    this.text,
  });

  List<RichTextNodeItem>? richTextNodes;
  String? text;

  DynamicDescModel.fromJson(Map<String, dynamic> json) {
    richTextNodes = json['rich_text_nodes'] != null
        ? json['rich_text_nodes']
            .map<RichTextNodeItem>((e) => RichTextNodeItem.fromJson(e))
            .toList()
        : [];
    text = json['text'];
  }
}

//
class DynamicMajorModel {
  DynamicMajorModel({
    this.article,
    this.archive,
    this.draw,
    this.ugcSeason,
    this.opus,
    this.pgc,
    this.liveRcmd,
    this.live,
    this.none,
    this.type,
    this.courses,
    this.common,
    this.music,
    this.blocked,
    this.medialist,
    this.subscriptionNew,
    this.upowerCommon,
  });
  DynamicArticle? article;
  DynamicArchiveModel? archive;
  DynamicDrawModel? draw;
  DynamicArchiveModel? ugcSeason;
  DynamicOpusModel? opus;
  DynamicArchiveModel? pgc;
  DynamicLiveModel? liveRcmd;
  DynamicLive2Model? live;
  DynamicNoneModel? none;
  // MAJOR_TYPE_DRAW 图片
  // MAJOR_TYPE_ARCHIVE 视频
  // MAJOR_TYPE_OPUS 图文/文章
  String? type;
  Map? courses;
  Map? common;
  Map? music;
  DynamicArchiveModel? coursesInfo;
  Common? commonInfo;
  Common? upowerCommon;
  Music? musicInfo;
  ModuleBlocked? blocked;
  Medialist? medialist;
  SubscriptionNew? subscriptionNew;

  DynamicMajorModel.fromJson(Map<String, dynamic> json) {
    article = json['article'] != null
        ? DynamicArticle.fromJson(json['article'])
        : null;
    archive = json['archive'] != null
        ? DynamicArchiveModel.fromJson(json['archive'])
        : null;
    draw =
        json['draw'] != null ? DynamicDrawModel.fromJson(json['draw']) : null;
    ugcSeason = json['ugc_season'] != null
        ? DynamicArchiveModel.fromJson(json['ugc_season'])
        : null;
    opus =
        json['opus'] != null ? DynamicOpusModel.fromJson(json['opus']) : null;
    pgc =
        json['pgc'] != null ? DynamicArchiveModel.fromJson(json['pgc']) : null;
    liveRcmd = json['live_rcmd'] != null
        ? DynamicLiveModel.fromJson(json['live_rcmd'])
        : null;
    live =
        json['live'] != null ? DynamicLive2Model.fromJson(json['live']) : null;
    none =
        json['none'] != null ? DynamicNoneModel.fromJson(json['none']) : null;
    type = json['type'];
    courses = json['courses'] ?? {};
    common = json['common'] ?? {};
    music = json['music'] ?? {};
    coursesInfo = json['courses'] != null
        ? DynamicArchiveModel.fromJson(json['courses'])
        : null;
    commonInfo =
        json['common'] != null ? Common.fromJson(json['common']) : null;
    upowerCommon = json['upower_common'] != null
        ? Common.fromJson(json['upower_common'])
        : null;
    musicInfo = json['music'] != null ? Music.fromJson(json['music']) : null;
    blocked = json['blocked'] != null
        ? ModuleBlocked.fromJson(json['blocked'])
        : null;
    medialist = json['medialist'] != null
        ? Medialist.fromJson(json['medialist'])
        : null;
    subscriptionNew = json['subscription_new'] != null
        ? SubscriptionNew.fromJson(json['subscription_new'])
        : null;
  }
}

class Common {
  Common({
    this.badge,
    this.bizType,
    this.cover,
    this.desc,
    this.id,
    this.jumpUrl,
    this.label,
    this.title,
  });

  Badge? badge;
  int? bizType;
  String? cover;
  String? desc;
  dynamic id;
  String? jumpUrl;
  String? label;
  String? title;

  Common.fromJson(Map<String, dynamic> json) {
    badge = json['badge'] == null ? null : Badge.fromJson(json['badge']);
    bizType = asInt(json['biz_type']);
    cover = json['cover'];
    desc = json['desc'];
    id = json['id'];
    jumpUrl = json['jump_url'];
    label = json['label'];
    title = json['title'];
  }
}

class Music {
  Music({
    this.id,
    this.cover,
    this.title,
    this.label,
    this.jumpUrl,
  });

  int? id;
  String? cover;
  String? title;
  String? label;
  String? jumpUrl;

  Music.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    cover = json['cover'];
    title = json['title'];
    label = json['label'];
    jumpUrl = json['jump_url'];
  }
}

class Medialist {
  dynamic id;
  String? cover;
  String? title;
  String? subTitle;
  String? jumpUrl;
  Badge? badge;

  Medialist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    title = json['title'];
    subTitle = json['sub_title'];
    jumpUrl = json['jump_url'];
    badge = json['badge'] == null ? null : Badge.fromJson(json['badge']);
  }
}

class SubscriptionNew {
  SubscriptionNew({
    this.liveRcmd,
  });

  LiveRcmd? liveRcmd;

  SubscriptionNew.fromJson(Map<String, dynamic> json) {
    liveRcmd =
        json['live_rcmd'] == null ? null : LiveRcmd.fromJson(json['live_rcmd']);
  }
}

class LiveRcmd {
  LiveRcmd({
    this.content,
  });

  LiveRcmdContent? content;

  LiveRcmd.fromJson(Map<String, dynamic> json) {
    final rawContent = json['content'];
    if (rawContent is String && rawContent.isNotEmpty) {
      content = LiveRcmdContent.fromJson(jsonDecode(rawContent));
    } else if (rawContent is Map<String, dynamic>) {
      content = LiveRcmdContent.fromJson(rawContent);
    }
  }
}

class LiveRcmdContent {
  LiveRcmdContent({
    this.livePlayInfo,
  });

  LivePlayInfo? livePlayInfo;

  LiveRcmdContent.fromJson(Map<String, dynamic> json) {
    livePlayInfo = json['live_play_info'] == null
        ? null
        : LivePlayInfo.fromJson(json['live_play_info']);
  }
}

class LivePlayInfo {
  LivePlayInfo({
    this.roomId,
    this.liveStatus,
    this.title,
    this.cover,
    this.areaName,
    this.watchedShow,
  });

  int? roomId;
  int? liveStatus;
  String? title;
  String? cover;
  String? areaName;
  Map? watchedShow;

  LivePlayInfo.fromJson(Map<String, dynamic> json) {
    roomId = asInt(json['room_id']);
    liveStatus = asInt(json['live_status']);
    title = json['title'];
    cover = json['cover'];
    areaName = json['area_name'];
    watchedShow = json['watched_show'];
  }
}

class DynamicArticle {
  List<String>? covers;
  String? desc;
  int? id;
  String? jump_url;
  String? title;
  String? label;

  DynamicArticle({
    this.covers,
    this.desc,
    this.id,
    this.jump_url,
    this.title,
    this.label,
  });

  factory DynamicArticle.fromJson(Map<String, dynamic> json) {
    return DynamicArticle(
      id: asInt(json['id']),
      title: json['title'],
      jump_url: json['jump_url'],
      desc: json['desc'],
      covers: json['covers'] != null ? List<String>.from(json['covers']) : null,
      label: json['label'],
    );
  }
}

class DynamicTopicModel {
  DynamicTopicModel({
    this.id,
    this.jumpUrl,
    this.name,
  });

  int? id;
  String? jumpUrl;
  String? name;

  DynamicTopicModel.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    jumpUrl = json['jump_url'];
    name = json['name'];
  }
}

class DynamicArchiveModel {
  DynamicArchiveModel({
    this.id,
    this.aid,
    this.badge,
    this.badgeInfo,
    this.bvid,
    this.cover,
    this.desc,
    this.disablePreview,
    this.durationText,
    this.jumpUrl,
    this.stat,
    this.title,
    this.type,
    this.epid,
    this.seasonId,
  });

  int? id;
  int? aid;
  Map? badge;
  Badge? badgeInfo;
  String? bvid;
  String? cover;
  String? desc;
  int? disablePreview;
  String? durationText;
  String? jumpUrl;
  Stat? stat;
  String? title;
  int? type;
  int? epid;
  int? seasonId;

  DynamicArchiveModel.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    aid = asInt(json['aid']);
    badge = json['badge'];
    badgeInfo = json['badge'] == null ? null : Badge.fromJson(json['badge']);
    bvid = json['bvid'] ?? json['epid']?.toString() ?? ' ';
    cover = json['cover'];
    desc = json['desc'];
    disablePreview = asInt(json['disable_preview']);
    durationText = json['duration_text'];
    jumpUrl = json['jump_url'];
    stat = json['stat'] != null ? Stat.fromJson(json['stat']) : null;
    title = json['title'];
    type = asInt(json['type']);
    epid = asInt(json['epid']);
    seasonId = asInt(json['season_id']);
  }
}

class Badge {
  Badge({
    this.text,
  });

  String? text;

  Badge.fromJson(Map<String, dynamic> json) {
    final rawText = json['text'];
    text = rawText == '投稿视频' ? null : rawText;
  }
}

class DynamicDrawModel {
  DynamicDrawModel({
    this.id,
    this.items,
  });

  int? id;
  List<DynamicDrawItemModel>? items;

  DynamicDrawModel.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    items = (json['items'] as List?)
        ?.map<DynamicDrawItemModel>((e) => DynamicDrawItemModel.fromJson(e))
        .toList();
  }
}

class DynamicOpusModel {
  DynamicOpusModel({
    this.jumpUrl,
    this.pics,
    this.summary,
    this.title,
  });

  String? jumpUrl;
  List<OpusPicsModel>? pics;
  SummaryModel? summary;
  String? title;
  DynamicOpusModel.fromJson(Map<String, dynamic> json) {
    jumpUrl = json['jump_url'];
    pics = json['pics'] != null
        ? json['pics']
            .map<OpusPicsModel>((e) => OpusPicsModel.fromJson(e))
            .toList()
        : [];
    summary =
        json['summary'] != null ? SummaryModel.fromJson(json['summary']) : null;
    title = json['title'];
  }
}

class SummaryModel {
  SummaryModel({
    this.richTextNodes,
    this.text,
  });

  List<RichTextNodeItem>? richTextNodes;
  String? text;

  SummaryModel.fromJson(Map<String, dynamic> json) {
    richTextNodes = (json['rich_text_nodes'] as List?)
        ?.map<RichTextNodeItem>((e) => RichTextNodeItem.fromJson(e))
        .toList();
    text = json['text'];
  }
}

class RichTextNodeItem {
  RichTextNodeItem({
    this.emoji,
    this.origText,
    this.text,
    this.type,
    this.rid,
    this.pics,
    this.dynPic,
    this.jumpUrl,
  });
  Emoji? emoji;
  String? origText;
  String? text;
  String? type;
  String? rid;
  List<OpusPicsModel>? pics;
  List<OpusPicsModel>? dynPic;
  String? jumpUrl;

  RichTextNodeItem.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null;
    origText = json['orig_text'];
    text = json['text'];
    type = json['type'];
    rid = json['rid'];
    pics =
        (json['pics'] as List?)?.map((e) => OpusPicsModel.fromJson(e)).toList();
    dynPic = (json['dyn_pic'] as List?)
        ?.map((e) => OpusPicsModel.fromJson(e))
        .toList();
    jumpUrl = json['jump_url'];
  }
}

class Emoji {
  Emoji({
    this.iconUrl,
    this.size,
    this.text,
    this.type,
  });

  String? iconUrl;
  String? gifUrl;
  String? webpUrl;
  String? url;
  double? size;
  String? text;
  int? type;
  Emoji.fromJson(Map<String, dynamic> json) {
    iconUrl = json['icon_url'];
    gifUrl = json['gif_url'];
    webpUrl = json['webp_url'];
    url = webpUrl ?? gifUrl ?? iconUrl;
    size = (json['size'] as num?)?.toDouble() ?? 1;
    text = json['text'];
    type = asInt(json['type']);
  }
}

class DynamicNoneModel {
  DynamicNoneModel({
    this.tips,
  });
  String? tips;
  DynamicNoneModel.fromJson(Map<String, dynamic> json) {
    tips = json['tips'];
  }
}

class OpusPicsModel {
  OpusPicsModel({
    this.width,
    this.height,
    this.size,
    this.src,
    this.url,
    this.liveUrl,
  });

  int? width;
  int? height;
  int? size;
  String? src;
  String? url;
  String? liveUrl;

  OpusPicsModel.fromJson(Map<String, dynamic> json) {
    width = asInt(json['width']);
    height = asInt(json['height']);
    size = asInt(json['size']) ?? 0;
    src = json['src'];
    url = json['url'];
    liveUrl = json['live_url'];
  }

  Map<String, dynamic> toJson() => {
        'img_width': width,
        'img_height': height,
        'img_size': size,
        'img_src': url,
      };
}

class OpusPicModel extends OpusPicsModel {
  OpusPicModel({
    super.width,
    super.height,
    super.size,
    super.src,
    super.url,
    super.liveUrl,
  });

  OpusPicModel.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class DynamicDrawItemModel {
  DynamicDrawItemModel({
    this.height,
    this.size,
    this.src,
    this.tags,
    this.width,
  });
  int? height;
  int? size;
  String? src;
  List? tags;
  int? width;
  DynamicDrawItemModel.fromJson(Map<String, dynamic> json) {
    height = asInt(json['height']);
    size = asInt(json['size']);
    src = json['src'];
    tags = json['tags'];
    width = asInt(json['width']);
  }
}

class DynamicLiveModel {
  DynamicLiveModel({
    this.content,
  });

  String? content;
  int? type;
  Map? livePlayInfo;
  int? uid;
  String? parentAreaName;
  int? roomId;
  String? liveId;
  int? liveStatus;
  String? cover;
  int? online;
  String? areaName;
  String? title;
  int? liveStartTime;
  Map? watchedShow;

  DynamicLiveModel.fromJson(Map<String, dynamic> json) {
    content = json['content']?.toString();
    if (json['content'] != null) {
      final data = json['content'] is String
          ? jsonDecode(json['content'])
          : json['content'];

      type = asInt(data['type']);
      livePlayInfo = data['live_play_info'];
      final liveInfo = livePlayInfo;
      if (liveInfo is Map) {
        uid = asInt(liveInfo['uid']);
        parentAreaName = liveInfo['parent_area_name'];
        roomId = asInt(liveInfo['room_id']);
        liveId = liveInfo['live_id']?.toString();
        liveStatus = asInt(liveInfo['live_status']);
        cover = liveInfo['cover'];
        online = asInt(liveInfo['online']);
        areaName = liveInfo['area_name'];
        title = liveInfo['title'];
        liveStartTime = asInt(liveInfo['live_start_time']);
        watchedShow = liveInfo['watched_show'];
      }
    }
  }
}

class DynamicLive2Model {
  DynamicLive2Model({
    this.badge,
    this.badgeInfo,
    this.cover,
    this.descFirst,
    this.descSecond,
    this.id,
    this.jumpUrl,
    this.liveState,
    this.reserveType,
    this.title,
  });

  Map? badge;
  Badge? badgeInfo;
  String? cover;
  String? descFirst;
  String? descSecond;
  int? id;
  String? jumpUrl;
  int? liveState;
  int? reserveType;
  String? title;

  DynamicLive2Model.fromJson(Map<String, dynamic> json) {
    badge = json['badge'];
    badgeInfo = json['badge'] == null ? null : Badge.fromJson(json['badge']);
    cover = json['cover'];
    descFirst = json['desc_first'];
    descSecond = json['desc_second'];
    id = asInt(json['id']);
    jumpUrl = json['jump_url'];
    liveState = asInt(json['live_state'] ?? json['liv_state']);
    reserveType = asInt(json['reserve_type']);
    title = json['title'];
  }
}

class ModuleTag {
  ModuleTag({
    this.text,
    this.jumpUrl,
  });

  String? text;
  String? jumpUrl;

  ModuleTag.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    jumpUrl = json['jump_url'];
  }
}

// 动态状态 转发、评论、点赞
class ModuleStatModel {
  ModuleStatModel({
    this.comment,
    this.forward,
    this.like,
    this.favorite,
  });

  Comment? comment;
  ForWard? forward;
  Like? like;
  Like? favorite;

  ModuleStatModel.fromJson(Map<String, dynamic> json) {
    comment =
        json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    forward =
        json['forward'] != null ? ForWard.fromJson(json['forward']) : null;
    like = json['like'] != null ? Like.fromJson(json['like']) : null;
    favorite =
        json['favorite'] != null ? Like.fromJson(json['favorite']) : null;
  }
}

// 动态状态 评论
class Comment {
  Comment({
    this.count,
    this.forbidden,
  });

  String? count;
  bool? forbidden;

  Comment.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : json['count'].toString();
    forbidden = json['forbidden'];
  }
}

class ForWard {
  ForWard({this.count, this.forbidden});
  String? count;
  bool? forbidden;

  ForWard.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : json['count'].toString();
    forbidden = json['forbidden'];
  }
}

// 动态状态 点赞
class Like {
  Like({
    this.count,
    this.forbidden,
    this.status,
  });

  String? count;
  bool? forbidden;
  bool? status;

  Like.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : json['count'].toString();
    forbidden = json['forbidden'];
    status = json['status'];
  }
}

class Stat {
  Stat({
    this.danmaku,
    this.play,
  });

  String? danmaku;
  String? play;

  Stat.fromJson(Map<String, dynamic> json) {
    danmaku = json['danmaku'];
    play = json['play'];
  }
}

class ArticleContentModel {
  int? align;
  int? paraType;
  ArticleText? text;
  ArticleFormat? format;
  ArticleLine? line;
  ArticlePic? pic;
  ArticleLinkCard? linkCard;
  ArticleCode? code;
  ArticleList? list;
  ArticleText? heading;

  ArticleContentModel.fromJson(Map<String, dynamic> json) {
    align = asInt(json['align']);
    paraType = asInt(json['para_type']);
    text = json['text'] == null ? null : ArticleText.fromJson(json['text']);
    format =
        json['format'] == null ? null : ArticleFormat.fromJson(json['format']);
    line = json['line'] == null ? null : ArticleLine.fromJson(json['line']);
    pic = json['pic'] == null ? null : ArticlePic.fromJson(json['pic']);
    linkCard = json['link_card'] == null
        ? null
        : ArticleLinkCard.fromJson(json['link_card']);
    code = json['code'] == null ? null : ArticleCode.fromJson(json['code']);
    list = json['list'] == null ? null : ArticleList.fromJson(json['list']);
    heading =
        json['heading'] == null ? null : ArticleText.fromJson(json['heading']);
  }
}

class ArticlePic {
  List<ArticlePic>? pics;
  int? style;
  String? url;
  double? width;
  double? height;
  num? size;
  String? liveUrl;
  bool? isLongPic;

  ArticlePic.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = (json['width'] as num?)?.toDouble();
    height = (json['height'] as num?)?.toDouble();
    size = json['size'];
    pics = (json['pics'] as List?)
        ?.map((item) => ArticlePic.fromJson(item))
        .toList();
    style = asInt(json['style']);
    liveUrl = json['live_url'];
    if (width != null && height != null && width != 0) {
      isLongPic = (height! / width!) > 2.5;
    }
  }
}

class ArticleLine {
  ArticleLine({
    this.pic,
  });

  ArticlePic? pic;

  ArticleLine.fromJson(Map<String, dynamic> json) {
    pic = json['pic'] == null ? null : ArticlePic.fromJson(json['pic']);
  }
}

class ArticleFormat {
  ArticleFormat({
    this.align,
  });

  int? align;

  ArticleFormat.fromJson(Map<String, dynamic> json) {
    align = asInt(json['align']);
  }
}

class ArticleText {
  ArticleText({
    this.nodes,
  });

  List<ArticleNode>? nodes;

  ArticleText.fromJson(Map<String, dynamic> json) {
    nodes = (json['nodes'] as List?)
        ?.map((item) => ArticleNode.fromJson(item))
        .toList();
  }
}

class ArticleNode {
  int? nodeType;
  ArticleWord? word;
  ArticleRich? rich;
  ArticleFormula? formula;
  String? type;

  ArticleNode.fromJson(Map<String, dynamic> json) {
    nodeType = asInt(json['node_type']);
    word = json['word'] == null ? null : ArticleWord.fromJson(json['word']);
    rich = json['rich'] == null ? null : ArticleRich.fromJson(json['rich']);
    formula = json['formula'] == null
        ? null
        : ArticleFormula.fromJson(json['formula']);
    type = json['type'];
  }
}

class ArticleFormula {
  String? latexContent;

  ArticleFormula.fromJson(Map<String, dynamic> json) {
    latexContent = json['latex_content'];
  }
}

class ArticleWord {
  String? words;
  double? fontSize;
  ArticleWordStyle? style;
  int? color;
  String? fontLevel;

  ArticleWord.fromJson(Map<String, dynamic> json) {
    words = json['words'];
    final rawFontSize = json['font_size'];
    if (rawFontSize is num && rawFontSize != 0) {
      fontSize = rawFontSize.toDouble();
    }
    style =
        json['style'] == null ? null : ArticleWordStyle.fromJson(json['style']);
    color = _parseHexColor(json['color']);
    fontLevel = json['font_level'];
  }

  double get effectiveFontSize =>
      fontSize ?? (fontLevel == 'small' ? 13.0 : 16.0);
}

class ArticleWordStyle {
  ArticleWordStyle({
    this.bold,
    this.italic,
    this.strikethrough,
  });

  bool? bold;
  bool? italic;
  bool? strikethrough;

  ArticleWordStyle.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
    italic = json['italic'];
    strikethrough = json['strikethrough'];
  }
}

class ArticleRich {
  ArticleWordStyle? style;
  String? jumpUrl;
  String? origText;
  String? text;
  String? type;
  String? rid;
  Emoji? emoji;

  ArticleRich.fromJson(Map<String, dynamic> json) {
    style =
        json['style'] == null ? null : ArticleWordStyle.fromJson(json['style']);
    jumpUrl = json['jump_url'];
    origText = json['orig_text'];
    text = json['text'];
    type = json['type'];
    rid = json['rid'];
    emoji = json['emoji'] == null ? null : Emoji.fromJson(json['emoji']);
  }
}

class ArticleLinkCard {
  ArticleCard? card;

  ArticleLinkCard.fromJson(Map<String, dynamic> json) {
    card = json['card'] == null ? null : ArticleCard.fromJson(json['card']);
  }
}

class ArticleCard {
  String? oid;
  String? type;
  Ugc? ugc;
  ArticleItemNull? itemNull;
  ArticleCommon? common;
  ArticleLive? live;
  ArticleOpus? opus;
  dynamic vote;
  Music? music;
  ArticleGoods? goods;

  ArticleCard.fromJson(Map<String, dynamic> json) {
    oid = json['oid']?.toString();
    type = json['type'];
    ugc = json['ugc'] == null ? null : Ugc.fromJson(json['ugc']);
    itemNull = json['item_null'] == null
        ? null
        : ArticleItemNull.fromJson(json['item_null']);
    common =
        json['common'] == null ? null : ArticleCommon.fromJson(json['common']);
    live = json['live'] == null ? null : ArticleLive.fromJson(json['live']);
    opus = json['opus'] == null ? null : ArticleOpus.fromJson(json['opus']);
    vote = json['vote'];
    music = json['music'] == null ? null : Music.fromJson(json['music']);
    goods = json['goods'] == null ? null : ArticleGoods.fromJson(json['goods']);
  }
}

class ArticleGoods {
  String? headIcon;
  String? headText;
  String? jumpUrl;
  List<GoodItem>? items;

  ArticleGoods.fromJson(Map<String, dynamic> json) {
    headIcon = json['head_icon'];
    headText = json['head_text'];
    jumpUrl = json['jump_url'];
    items = (json['items'] as List?)
        ?.map((item) => GoodItem.fromJson(item))
        .toList();
  }
}

class ArticleOpus {
  int? authorMid;
  String? authorName;
  String? cover;
  String? jumpUrl;
  String? title;
  int? statView;

  ArticleOpus.fromJson(Map<String, dynamic> json) {
    authorMid = asInt(json['author']?['mid']);
    authorName = json['author']?['name'];
    cover = json['cover'];
    jumpUrl = json['jump_url'];
    title = json['title'];
    statView = asInt(json['stat']?['view']);
  }
}

class ArticleLive {
  String? cover;
  String? descFirst;
  String? descSecond;
  String? title;
  String? jumpUrl;
  int? id;
  int? liveState;
  int? reserveType;
  String? badgeText;

  ArticleLive.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    descFirst = json['desc_first'];
    descSecond = json['desc_second'];
    title = json['title'];
    jumpUrl = json['jump_url'];
    id = asInt(json['id']);
    liveState = asInt(json['live_state']);
    reserveType = asInt(json['reserve_type']);
    badgeText = json['badge']?['text'];
  }
}

class ArticleCommon {
  ArticleCommon({
    this.cover,
    this.desc,
    this.desc1,
    this.desc2,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.style,
    this.subType,
    this.title,
  });

  String? cover;
  String? desc;
  String? desc1;
  String? desc2;
  String? headText;
  String? idStr;
  String? jumpUrl;
  int? style;
  String? subType;
  String? title;
  String? titlePrefix;

  ArticleCommon.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    desc = json['desc'];
    desc1 = json['desc1'];
    desc2 = json['desc2'];
    headText = json['head_text'];
    idStr = json['id_str'];
    jumpUrl = json['jump_url'];
    style = asInt(json['style']);
    subType = json['sub_type'];
    title = json['title'];
    titlePrefix = json['title_prefix'];
  }
}

class ArticleItemNull {
  ArticleItemNull({
    this.icon,
    this.text,
  });

  String? icon;
  String? text;

  ArticleItemNull.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    text = json['text'];
  }
}

class ArticleList {
  List<ArticleListItem>? items;
  int? style;

  ArticleList.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List?)
        ?.map((e) => ArticleListItem.fromJson(e))
        .toList();
    style = asInt(json['style']);
  }
}

class ArticleListItem {
  int? level;
  int? order;
  List<ArticleNode>? nodes;

  ArticleListItem.fromJson(Map<String, dynamic> json) {
    level = asInt(json['level']);
    order = asInt(json['order']);
    nodes =
        (json['nodes'] as List?)?.map((e) => ArticleNode.fromJson(e)).toList();
  }
}

class ArticleCode {
  String? content;
  String? lang;

  ArticleCode.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    lang = json['lang'];
  }
}

int? _parseHexColor(dynamic value) {
  if (value is! String || !value.startsWith('#')) {
    return null;
  }
  final hex = value.substring(1);
  return int.tryParse(hex.length == 6 ? 'ff$hex' : hex, radix: 16);
}
