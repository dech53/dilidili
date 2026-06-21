import 'package:dilidili/model/space/space/archive.dart';
import 'package:dilidili/model/space/space/article.dart';
import 'package:dilidili/model/space/space/audios.dart';
import 'package:dilidili/model/space/space/card.dart';
import 'package:dilidili/model/space/space/cheese.dart';
import 'package:dilidili/model/space/space/coin_archive.dart';
import 'package:dilidili/model/space/space/comic.dart';
import 'package:dilidili/model/space/space/elec.dart';
import 'package:dilidili/model/space/space/favourite2.dart';
import 'package:dilidili/model/space/space/guard.dart';
import 'package:dilidili/model/space/space/images.dart';
import 'package:dilidili/model/space/space/like_archive.dart';
import 'package:dilidili/model/space/space/live.dart';
import 'package:dilidili/model/space/space/reservation_card_list.dart';
import 'package:dilidili/model/space/space/season.dart';
import 'package:dilidili/model/space/space/series.dart';
import 'package:dilidili/model/space/space/setting.dart';
import 'package:dilidili/model/space/space/tab.dart';
import 'package:dilidili/model/space/space/tab2.dart';
import 'package:dilidili/model/space/space/ugc_season.dart';

class SpaceData {
  int? relation;
  int? medal;
  String? defaultTab;
  SpaceSetting? setting;
  SpaceTab? tab;
  SpaceCard? card;
  SpaceImages? images;
  Live? live;
  Elec? elec;
  Archive? archive;
  SpaceSeries? series;
  Article? article;
  SpaceSeason? season;
  CoinArchive? coinArchive;
  LikeArchive? likeArchive;
  Audios? audios;
  Favourite2? favourite2;
  Comic? comic;
  UgcSeason? ugcSeason;
  Cheese? cheese;
  Guard? guard;
  List<SpaceTab2>? tab2;
  int? relSpecial;
  bool? hasItem;
  List<ReservationCardItem>? reservationCardList;

  SpaceData({
    this.relation,
    this.medal,
    this.defaultTab,
    this.setting,
    this.tab,
    this.card,
    this.images,
    this.live,
    this.elec,
    this.archive,
    this.series,
    this.article,
    this.season,
    this.coinArchive,
    this.likeArchive,
    this.audios,
    this.favourite2,
    this.comic,
    this.ugcSeason,
    this.cheese,
    this.guard,
    this.tab2,
    this.relSpecial,
    this.reservationCardList,
  });

  SpaceData.fromJson(Map<String, dynamic> json) {
    relation = json['relation'] as int?;
    medal = json['medal'] as int?;
    defaultTab = json['default_tab'] as String?;
    setting = json['setting'] == null
        ? null
        : SpaceSetting.fromJson(json['setting'] as Map<String, dynamic>);
    tab = json['tab'] == null
        ? null
        : SpaceTab.fromJson(json['tab'] as Map<String, dynamic>);
    card = json['card'] == null
        ? null
        : SpaceCard.fromJson(json['card'] as Map<String, dynamic>);
    images = json['images'] == null
        ? null
        : SpaceImages.fromJson(json['images'] as Map<String, dynamic>);
    live = json['live'] == null
        ? null
        : Live.fromJson(json['live'] as Map<String, dynamic>);
    elec = json['elec'] == null
        ? null
        : Elec.fromJson(json['elec'] as Map<String, dynamic>);
    archive = json['archive'] == null
        ? null
        : Archive.fromJson(json['archive'] as Map<String, dynamic>);
    series = json['series'] == null
        ? null
        : SpaceSeries.fromJson(json['series'] as Map<String, dynamic>);
    article = json['article'] == null
        ? null
        : Article.fromJson(json['article'] as Map<String, dynamic>);
    season = json['season'] == null
        ? null
        : SpaceSeason.fromJson(json['season'] as Map<String, dynamic>);
    coinArchive = json['coin_archive'] == null
        ? null
        : CoinArchive.fromJson(json['coin_archive'] as Map<String, dynamic>);
    likeArchive = json['like_archive'] == null
        ? null
        : LikeArchive.fromJson(json['like_archive'] as Map<String, dynamic>);
    audios = json['audios'] == null
        ? null
        : Audios.fromJson(json['audios'] as Map<String, dynamic>);
    favourite2 = json['favourite2'] == null
        ? null
        : Favourite2.fromJson(json['favourite2'] as Map<String, dynamic>);
    comic = json['comic'] == null
        ? null
        : Comic.fromJson(json['comic'] as Map<String, dynamic>);
    ugcSeason = json['ugc_season'] == null
        ? null
        : UgcSeason.fromJson(json['ugc_season'] as Map<String, dynamic>);
    cheese = json['cheese'] == null
        ? null
        : Cheese.fromJson(json['cheese'] as Map<String, dynamic>);
    guard = json['guard'] == null
        ? null
        : Guard.fromJson(json['guard'] as Map<String, dynamic>);
    tab2 = (json['tab2'] as List<dynamic>?)
        ?.map((e) => SpaceTab2.fromJson(e as Map<String, dynamic>))
        .toList();
    relSpecial = (json['rel_special'] as num?)?.toInt();
    reservationCardList = (json['reservation_card_list'] as List<dynamic>?)
        ?.map((e) => ReservationCardItem.fromJson(e))
        .toList();
    hasItem = archive?.item?.isNotEmpty == true ||
        favourite2?.item?.isNotEmpty == true ||
        coinArchive?.item?.isNotEmpty == true ||
        likeArchive?.item?.isNotEmpty == true ||
        article?.item?.isNotEmpty == true ||
        audios?.item?.isNotEmpty == true ||
        comic?.item?.isNotEmpty == true ||
        season?.item?.isNotEmpty == true;
  }

  @override
  String toString() {
    final String tab2Text = tab2 == null
        ? 'null'
        : '[${tab2!.map((item) {
            return '{title: ${item.title}, param: ${item.param}, '
                'items: ${item.items?.length ?? 0}}';
          }).join(', ')}]';
    final String tabText = tab == null
        ? 'null'
        : '{archive: ${tab?.archive}, article: ${tab?.article}, '
            'favorite: ${tab?.favorite}, bangumi: ${tab?.bangumi}, '
            'dynamic: ${tab?.dynam1c}, opus: ${tab?.opus}, '
            'series: ${tab?.series}, cheese: ${tab?.cheese}, '
            'shop: ${tab?.shop}}';
    final String itemCounts = '{archive: ${archive?.item?.length ?? 0}, '
        'series: ${series?.item?.length ?? 0}, '
        'article: ${article?.item?.length ?? 0}, '
        'season: ${season?.item?.length ?? 0}, '
        'coinArchive: ${coinArchive?.item?.length ?? 0}, '
        'likeArchive: ${likeArchive?.item?.length ?? 0}, '
        'audios: ${audios?.item?.length ?? 0}, '
        'favourite2: ${favourite2?.item?.length ?? 0}, '
        'comic: ${comic?.item?.length ?? 0}}';
    return 'SpaceData(relation: $relation, medal: $medal, '
        'defaultTab: $defaultTab, hasItem: $hasItem, '
        'relSpecial: $relSpecial, '
        'card: {mid: ${card?.mid}, name: ${card?.name}, '
        'fans: ${card?.fans}, attention: ${card?.attention}, '
        'sign: ${card?.sign}}, '
        'images: {imgUrl: ${images?.imgUrl}, '
        'nightImgurl: ${images?.nightImgurl}, '
        'hasCollectionTopSimple: ${images?.collectionTopSimple != null}}, '
        'tab: $tabText, tab2: $tab2Text, itemCounts: $itemCounts, '
        'reservationCardList: ${reservationCardList?.length ?? 0})';
  }
}
