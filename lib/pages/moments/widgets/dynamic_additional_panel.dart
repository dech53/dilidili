import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

Widget? dynamicAdditionalWidget(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required Object? idStr,
  required DynamicAddModel additional,
}) {
  final bgColor = floor == 1
      ? theme.dividerColor.withOpacity(0.08)
      : theme.colorScheme.surface;
  final borderRadius = floor == 1 ? null : BorderRadius.circular(8);

  Widget? child;
  switch (additional.type) {
    case 'ADDITIONAL_TYPE_UGC':
      final ugc = additional.ugc;
      if (ugc == null) break;
      child = InkWell(
        borderRadius: borderRadius,
        onTap: () => _openUgc(ugc),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              NetworkImgLayer(width: 120, height: 75, src: ugc.cover),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ugc.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (ugc.descSecond?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        ugc.descSecond!,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: theme.textTheme.labelMedium?.fontSize,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      break;
    case 'ADDITIONAL_TYPE_RESERVE':
      final reserve = additional.reserve;
      if (reserve == null || reserve.state == -1 || reserve.title == null) {
        break;
      }
      final desc1 = reserve.desc1Info?.text ?? reserve.desc1?['text'];
      final desc2 = reserve.desc2Info?.text ?? reserve.desc2?['text'];
      final desc3 = reserve.desc3Info?.text ?? reserve.desc3?['text'];
      child = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reserve.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: theme.colorScheme.outline,
                        fontSize: 13,
                      ),
                      children: [
                        if (desc1 != null) TextSpan(text: desc1),
                        if (desc2 != null) TextSpan(text: '    $desc2'),
                        if (desc3 != null) ...[
                          const TextSpan(text: '\n'),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.card_giftcard,
                              size: 17,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' $desc3',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (reserve.buttonInfo != null) ...[
              const SizedBox(width: 10),
              FilledButton.tonal(
                onPressed: reserve.buttonInfo?.jumpUrl == null
                    ? null
                    : () => _openUrl(reserve.buttonInfo!.jumpUrl!),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  reserve.buttonInfo?.jumpText ??
                      reserve.buttonInfo?.checkText ??
                      reserve.buttonInfo?.uncheckText ??
                      '预约',
                ),
              ),
            ],
          ],
        ),
      );
      break;
    case 'ADDITIONAL_TYPE_GOODS':
      final goods = additional.goods;
      if (goods?.items?.isNotEmpty != true) break;
      child = Column(
        children: goods!.items!.map((item) {
          return InkWell(
            borderRadius: borderRadius,
            onTap: item.jumpUrl == null ? null : () => _openUrl(item.jumpUrl!),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  if (item.cover?.isNotEmpty == true) ...[
                    NetworkImgLayer(width: 45, height: 45, src: item.cover),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.price?.isNotEmpty == true)
                          Text(
                            '${item.price} 起',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                      ],
                    ),
                  ),
                  if (item.jumpDesc?.isNotEmpty == true) ...[
                    const SizedBox(width: 10),
                    FilledButton.tonal(
                      onPressed: item.jumpUrl == null
                          ? null
                          : () => _openUrl(item.jumpUrl!),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(item.jumpDesc!),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      );
      break;
    case 'ADDITIONAL_TYPE_VOTE':
      final vote = additional.vote;
      if (vote == null) break;
      child = InkWell(
        borderRadius: borderRadius,
        onTap: () => _openVote(vote, idStr),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                  color: floor == 1
                      ? theme.colorScheme.surface
                      : theme.dividerColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vote.title ?? '投票',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${NumUtils.int2Num(vote.joinNum)}人参与',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.tonal(
                onPressed: () => _openVote(vote, idStr),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('参与'),
              ),
            ],
          ),
        ),
      );
      break;
    case 'ADDITIONAL_TYPE_COMMON':
      final common = additional.common;
      if (common == null) break;
      child = InkWell(
        borderRadius: borderRadius,
        onTap: common.jumpUrl == null ? null : () => _openUrl(common.jumpUrl!),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (common.cover?.isNotEmpty == true) ...[
                NetworkImgLayer(width: 45, height: 45, src: common.cover),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (common.title?.isNotEmpty == true) Text(common.title!),
                    if (common.desc1?.isNotEmpty == true)
                      Text(
                        common.desc1!,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                    if (common.desc2?.isNotEmpty == true)
                      Text(
                        common.desc2!,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      break;
    case 'ADDITIONAL_TYPE_UPOWER_LOTTERY':
      final lottery = additional.upowerLottery;
      if (lottery == null) break;
      child = InkWell(
        borderRadius: borderRadius,
        onTap:
            lottery.jumpUrl == null ? null : () => _openUrl(lottery.jumpUrl!),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (lottery.title?.isNotEmpty == true) Text(lottery.title!),
                    if (lottery.hint?.text?.isNotEmpty == true)
                      Text(
                        lottery.hint!.text!,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              if (lottery.button?.jumpStyle?.text != null) ...[
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: lottery.button?.jumpUrl == null
                      ? null
                      : () => _openUrl(lottery.button!.jumpUrl!),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(lottery.button!.jumpStyle!.text!),
                ),
              ],
            ],
          ),
        ),
      );
      break;
  }

  if (child == null) return null;
  return Padding(
    padding: floor == 1
        ? const EdgeInsets.fromLTRB(12, 2, 12, 6)
        : const EdgeInsets.only(top: 4),
    child: Material(
      color: bgColor,
      borderRadius: borderRadius,
      child: child,
    ),
  );
}

void _openUrl(String url) {
  Get.toNamed('/webview', parameters: {
    'url': url,
    'type': 'url',
    'pageTitle': '',
  });
}

Future<void> _openUgc(Ugc ugc) async {
  final text = ugc.jumpUrl ?? '';
  final match =
      RegExp(r'BV[0-9A-Za-z]{10}', caseSensitive: false).firstMatch(text);
  if (match == null) {
    if (text.isNotEmpty) _openUrl(text);
    return;
  }
  final bvid = match.group(0)!;
  try {
    final cid = await SearchHttp.ab2c(bvid: bvid);
    Get.toNamed('/video/bvid=$bvid', arguments: {
      'pic': ugc.cover,
      'heroTag': bvid,
      'bvid': bvid,
      'cid': cid.toString(),
    });
  } catch (err) {
    SmartDialog.showToast(err.toString());
  }
}

void _openVote(Vote vote, Object? idStr) {
  final voteId = vote.voteId;
  if (voteId == null) return;
  final dynamicId = idStr?.toString();
  _openUrl(
    'https://t.bilibili.com/vote/h5/index/#/result?vote_id=$voteId'
    '${dynamicId == null ? '' : '&dynamic_id=$dynamicId'}&isWeb=1',
  );
}
