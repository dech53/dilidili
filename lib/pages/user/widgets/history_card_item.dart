import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/live/item.dart';
import 'package:dilidili/model/user/history.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/route_push.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

/// 观看记录快捷卡片（用户页面横向列表）
class HistoryCardItem extends StatelessWidget {
  const HistoryCardItem({super.key, required this.item});

  final HisListItem item;

  // 宽高比与观看记录大图区一致（16:10）
  static const double _cardWidth = 180.0;
  static const double _cardHeight = 110.0;

  String? get _business => item.history?.business;

  bool get _isArticle => _business?.contains('article') == true;

  bool get _isLive => _business == 'live';

  bool get _isPgc => _business == 'pgc';

  bool get _isCheese => _business == 'cheese';

  bool get _isVideo => !_isArticle && !_isLive && !_isPgc && !_isCheese;

  Future<void> _onTap() async {
    final History? history = item.history;
    if (history == null) return;

    if (_isArticle) {
      final int? id = _business == 'article-list' ? history.cid : history.oid;
      if (id == null) return;
      Get.toNamed(
        '/read',
        parameters: {
          'title': item.title ?? '',
          'id': id.toString(),
          'articleType': 'read',
        },
      );
      return;
    }

    if (_isLive) {
      if (item.liveStatus != 1 || history.oid == null) {
        SmartDialog.showToast('直播未开播');
        return;
      }
      final LiveItemModel liveItem = LiveItemModel.fromJson({
        'face': item.authorFace,
        'roomid': history.oid,
        'pic': item.cover,
        'title': item.title,
        'uname': item.authorName,
        'cover': item.cover,
      });
      Get.toNamed(
        '/liveRoom?roomid=${history.oid}',
        arguments: {'liveItem': liveItem},
      );
      return;
    }

    if (_isPgc && history.epid != null) {
      await RoutePush.bangumiPush(
        null,
        history.epid,
        heroTag: StringUtils.makeHeroTag(history.epid),
      );
      return;
    }

    if (_isCheese && item.uri?.isNotEmpty == true) {
      final String url =
          item.uri!.startsWith('//') ? 'https:${item.uri}' : item.uri!;
      Get.toNamed(
        '/webview',
        parameters: {
          'url': url,
          'type': 'webview',
          'pageTitle': item.title ?? '',
        },
      );
      return;
    }

    final int? aid = history.oid;
    if (aid == null) return;
    final String bvid = history.bvid ?? IdUtils.av2bv(aid);
    final int cid = history.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
    if (cid <= 0) {
      SmartDialog.showToast('获取视频信息失败');
      return;
    }
    Get.toNamed(
      '/video/bvid=$bvid',
      arguments: {
        'heroTag': StringUtils.makeHeroTag(aid),
        'bvid': bvid,
        'cid': cid.toString(),
        'pic': item.cover,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasDuration = item.duration != null && item.duration != 0;
    final String coverSrc;
    if (item.cover?.isNotEmpty == true) {
      coverSrc = item.cover!;
    } else if (item.covers?.isNotEmpty == true) {
      coverSrc = item.covers!.first.toString();
    } else {
      coverSrc = '';
    }

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onInverseSurface.withValues(
                    alpha: 0.4,
                  ),
                  offset: const Offset(6, -8),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                width: _cardWidth,
                height: _cardHeight,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    NetworkImgLayer(
                      src: coverSrc,
                      width: _cardWidth,
                      height: _cardHeight,
                    ),
                    if (_isLive)
                      PBadge(
                        text: item.liveStatus == 1 ? '直播中' : '未开播',
                        top: 6,
                        right: 6,
                        type: item.liveStatus == 1 ? 'primary' : 'gray',
                      )
                    else if (_isArticle)
                      const PBadge(
                        text: '专栏',
                        top: 6,
                        right: 6,
                        type: 'color',
                      )
                    else if (item.badge?.isNotEmpty == true)
                      PBadge(
                        text: item.badge!,
                        top: 6,
                        right: 6,
                      ),
                    if (_isVideo && hasDuration)
                      PBadge(
                        text: item.progress == -1
                            ? '已看完'
                            : NumUtils.int2time(item.progress ?? 0),
                        right: 6,
                        bottom: 6,
                        type: 'gray',
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: _cardWidth,
            child: Text(
              ' ${item.title ?? ''}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: _cardWidth,
            child: Text(
              ' ${item.authorName ?? item.showTitle ?? ''}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
