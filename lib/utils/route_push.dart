import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/bangumi/info.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class RoutePush {
  // 番剧跳转
  static Future<void> bangumiPush(int? seasonId, int? epId,
      {String? heroTag}) async {
    SmartDialog.showLoading<dynamic>(msg: '获取中...');
    try {
      var result = await SearchHttp.bangumiInfo(seasonId: seasonId, epId: epId);
      await SmartDialog.dismiss();
      if (result['status']) {
        if (result['data'].episodes.isEmpty) {
          SmartDialog.showToast('资源获取失败');
          return;
        }
        final BangumiInfoModel bangumiDetail = result['data'];
        final EpisodeItem episode = bangumiDetail.episodes!.first;
        final int epId = episode.id!;
        final int cid = episode.cid!;
        final String bvid = episode.bvid!;
        final String cover = episode.cover!;
        final Map arguments = <String, dynamic>{
          'pic': cover,
          'videoType': SearchType.media_bangumi,
          'bvid': bvid,
          'cid': cid.toString(),
          'epId': epId.toString(),
          // 'bangumiItem': bangumiDetail,
        };
        arguments['heroTag'] = heroTag ?? StringUtils.makeHeroTag(cid);
        Get.toNamed(
          '/video/bvid=$bvid',
          arguments: arguments,
        );
      } else {
        SmartDialog.showToast(result['msg']);
      }
    } catch (e) {
      SmartDialog.showToast('番剧获取失败：$e');
    }
  }

  // 登录跳转
  static Future<void> loginPush() async {
    await Get.toNamed(
      '/webview',
      parameters: {
        'url': 'https://passport.bilibili.com/h5-app/passport/login',
        'type': 'login',
        'pageTitle': '登录bilibili',
      },
    );
  }

  // 登录跳转
  static Future<void> loginRedirectPush() async {
    await Get.offAndToNamed(
      '/webview',
      parameters: {
        'url': 'https://passport.bilibili.com/h5-app/passport/login',
        'type': 'login',
        'pageTitle': '登录bilibili',
      },
    );
  }
}
