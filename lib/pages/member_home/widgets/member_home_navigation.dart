import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/space/space_archive/item.dart';
import 'package:dilidili/model/space/space_article/item.dart';
import 'package:dilidili/model/space/space_audio/item.dart';
import 'package:dilidili/model/space/space_fav/list.dart';
import 'package:dilidili/model/user/fav_folder.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/route_push.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MemberHomeNavigation {
  const MemberHomeNavigation._();

  static final RegExp _pgcUriPattern = RegExp(r'(ep|ss)(\d+)');

  static Future<void> openArchive(SpaceArchiveItem item) async {
    final int? aid = int.tryParse(item.param ?? '');
    final String? bvid = item.bvid ?? (aid == null ? null : IdUtils.av2bv(aid));

    if (item.goto == 'bangumi') {
      final int? epId = int.tryParse(item.param ?? '');
      if (epId != null) {
        await RoutePush.bangumiPush(
          null,
          epId,
          heroTag: StringUtils.makeHeroTag(epId),
        );
        return;
      }
      if (await _openPgcFromUri(item.uri)) return;
      openWeb(item.uri, item.title);
      return;
    }

    if (item.isPgc == true) {
      if (await _openPgcFromUri(item.uri)) return;
      openWeb(item.uri, item.title);
      return;
    }

    if ((item.goto == 'av' || item.goto == null) && bvid != null) {
      final int cid = item.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
      if (cid <= 0) {
        SmartDialog.showToast('获取视频信息失败');
        return;
      }
      Get.toNamed(
        '/video/bvid=$bvid',
        arguments: {
          'heroTag': StringUtils.makeHeroTag(aid ?? bvid),
          'bvid': bvid,
          'cid': cid.toString(),
          'pic': item.cover,
        },
      );
      return;
    }
    openWeb(item.uri, item.title);
  }

  static Future<bool> _openPgcFromUri(String? uri) async {
    if (uri == null || uri.isEmpty) return false;
    final RegExpMatch? match = _pgcUriPattern.firstMatch(uri);
    if (match == null) return false;

    final int? id = int.tryParse(match.group(2)!);
    if (id == null) return false;
    final bool isSeason = match.group(1) == 'ss';
    await RoutePush.bangumiPush(
      isSeason ? id : null,
      isSeason ? null : id,
      heroTag: StringUtils.makeHeroTag(id),
    );
    return true;
  }

  static Future<void> openSeason(SpaceArchiveItem item) async {
    final int? seasonId = int.tryParse(item.param ?? '');
    if (seasonId != null) {
      await RoutePush.bangumiPush(
        seasonId,
        null,
        heroTag: StringUtils.makeHeroTag(seasonId),
      );
      return;
    }
    if (await _openPgcFromUri(item.uri)) return;
    openWeb(item.uri, item.title);
  }

  static Future<void> openAudio(SpaceAudioItem item) async {
    if (item.bvid?.isNotEmpty == true || item.aid != null) {
      final String bvid = item.bvid ?? IdUtils.av2bv(item.aid!);
      final int cid =
          item.cid ?? await SearchHttp.ab2c(aid: item.aid, bvid: bvid);
      if (cid > 0) {
        Get.toNamed(
          '/video/bvid=$bvid',
          arguments: {
            'heroTag': StringUtils.makeHeroTag(item.aid ?? bvid),
            'bvid': bvid,
            'cid': cid.toString(),
            'pic': item.cover,
          },
        );
        return;
      }
    }
    if (item.id != null) {
      openWeb('https://www.bilibili.com/audio/au${item.id}', item.title);
    }
  }

  static void openArticle(SpaceArticleItem item) {
    final String? uri = item.uri;
    if (uri == null || uri.isEmpty) return;
    final String url = _normalUrl(uri);

    final RegExpMatch? opusMatch = RegExp(r'/opus/(\d+)').firstMatch(url);
    if (opusMatch != null) {
      Get.toNamed('/opus', parameters: {
        'title': item.title ?? '',
        'id': opusMatch.group(1)!,
        'articleType': 'opus',
      });
      return;
    }

    final RegExpMatch? cvMatch = RegExp(r'/read/cv(\d+)').firstMatch(url);
    if (cvMatch != null) {
      Get.toNamed('/read', parameters: {
        'title': item.title ?? '',
        'id': cvMatch.group(1)!,
        'articleType': 'cv',
      });
      return;
    }
    openWeb(url, item.title);
  }

  static void openFavorite(
    SpaceFavItemModel item, {
    required bool isOwner,
    String? heroTag,
  }) {
    final int? mediaId = item.mediaId ?? item.id;
    if (mediaId == null) return;
    final String resolvedHeroTag = heroTag ?? StringUtils.makeHeroTag(mediaId);
    final favFolderItem = FavFolderItemData(
      id: mediaId,
      fid: item.fid,
      mid: item.mid,
      attr: item.attr,
      title: item.title,
      cover: item.cover,
      upper: item.upper == null
          ? null
          : Upper(
              mid: item.upper!.mid,
              name: item.upper!.name,
              face: item.upper!.face,
            ),
      mediaCount: item.count ?? item.mediaCount,
      viewCount: item.viewCount,
      type: item.type,
    );
    Get.toNamed(
      '/favDetail',
      arguments: {
        'favFolderItem': favFolderItem,
        'heroTag': resolvedHeroTag,
        'mediaId': mediaId.toString(),
        'isOwner': isOwner ? '1' : '0',
      },
    );
  }

  static void openWeb(String? rawUrl, String? title) {
    if (rawUrl == null || rawUrl.isEmpty) {
      SmartDialog.showToast('暂不支持打开');
      return;
    }
    Get.toNamed('/webview', parameters: {
      'url': _normalUrl(rawUrl),
      'type': 'webview',
      'pageTitle': title ?? '',
    });
  }

  static String _normalUrl(String rawUrl) {
    return rawUrl.startsWith('//') ? 'https:$rawUrl' : rawUrl;
  }
}
