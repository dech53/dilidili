import 'dart:convert';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

enum MsgType {
  invalid(value: 0, label: "空空的~"),
  text(value: 1, label: "文本消息"),
  pic(value: 2, label: "图片消息"),
  audio(value: 3, label: "语音消息"),
  share(value: 4, label: "分享消息"),
  revoke(value: 5, label: "撤回消息"),
  customFace(value: 6, label: "自定义表情"),
  shareV2(value: 7, label: "分享v2消息"),
  sysCancel(value: 8, label: "系统撤销"),
  miniProgram(value: 9, label: "小程序"),
  notifyMsg(value: 10, label: "业务通知"),
  archiveCard(value: 11, label: "投稿卡片"),
  articleCard(value: 12, label: "专栏卡片"),
  picCard(value: 13, label: "图片卡片"),
  commonShare(value: 14, label: "异形卡片"),
  autoReplyPush(value: 16, label: "自动回复推送"),
  notifyText(value: 18, label: "文本提示");

  final int value;
  final String label;
  const MsgType({required this.value, required this.label});

  static MsgType parse(int? value) {
    return MsgType.values
        .firstWhere((e) => e.value == value, orElse: () => MsgType.invalid);
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.item,
    this.eInfos,
  });

  final dynamic item;
  final List? eInfos;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MsgType msgType = MsgType.parse(item.msgType);
    final bool isOwner = item.senderUid.toString() == SPStorage.userID;
    final bool isRevoke = msgType == MsgType.revoke;
    if (isRevoke) return const SizedBox.shrink();

    final bool isSystem = msgType == MsgType.notifyText ||
        msgType == MsgType.notifyMsg ||
        msgType == MsgType.picCard ||
        msgType == MsgType.autoReplyPush;
    final bool isPic = msgType == MsgType.pic || msgType == MsgType.customFace;
    final Color textColor = isOwner
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;
    final dynamic content = item.content ?? '';

    Widget child;
    try {
      child = _messageContent(
        context: context,
        theme: theme,
        content: content,
        msgType: msgType,
        textColor: textColor,
      );
    } catch (err) {
      child = _fallbackContent(content, textColor, err: err);
    }

    if (!isSystem) {
      child = Row(
        mainAxisAlignment:
            isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              color: isOwner
                  ? colorScheme.secondaryContainer
                  : colorScheme.onInverseSurface,
              borderRadius: isOwner
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(6),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(16),
                    ),
            ),
            padding: isPic
                ? const EdgeInsets.only(top: 8, bottom: 6, left: 8, right: 8)
                : const EdgeInsets.only(top: 8, bottom: 6, left: 12, right: 12),
            child: Column(
              crossAxisAlignment:
                  isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                child,
                if (item.msgStatus == 1) ...[
                  const SizedBox(height: 2),
                  Text(
                    '已撤回',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    final String timeText = _chatTime(item.timestamp);
    return Column(
      children: [
        if (timeText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 18),
            child: Text(
              timeText,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: child,
        ),
      ],
    );
  }

  Widget _messageContent({
    required BuildContext context,
    required ThemeData theme,
    required dynamic content,
    required MsgType msgType,
    required Color textColor,
  }) {
    switch (msgType) {
      case MsgType.notifyMsg:
        return _systemNotice(theme, content);
      case MsgType.picCard:
        return _pictureCard(context, content);
      case MsgType.notifyText:
        return _tipMessage(theme, content);
      case MsgType.text:
        return _richTextMessage(content, textColor);
      case MsgType.pic:
      case MsgType.customFace:
        return _imageMessage(content);
      case MsgType.shareV2:
        return _shareV2(context, content, textColor);
      case MsgType.archiveCard:
        return _archiveCard(content, textColor);
      case MsgType.autoReplyPush:
        return _autoReplyPush(context, theme, content, textColor);
      default:
        return _fallbackContent(content, textColor);
    }
  }

  Widget _richTextMessage(dynamic content, Color textColor) {
    final String text = content is Map
        ? content['content']?.toString() ?? ''
        : content.toString();
    final TextStyle style = TextStyle(
      color: textColor,
      letterSpacing: 0.6,
      height: 1.5,
    );

    if (eInfos == null || eInfos!.isEmpty) {
      return SelectableText(text, style: style);
    }

    final List<InlineSpan> children = [];
    final Map<String, String> emojiMap = {};
    for (final e in eInfos!) {
      emojiMap[e['text']] = e['url'];
    }

    text.splitMapJoin(
      RegExp(r"\[[^\[\]]+\]"),
      onMatch: (Match match) {
        final String emojiKey = match[0]!;
        final String? url = emojiMap[emojiKey];
        if (url != null) {
          children.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: NetworkImgLayer(
                width: 22,
                height: 22,
                src: url,
              ),
            ),
          );
        } else {
          children.add(TextSpan(text: emojiKey, style: style));
        }
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );

    return SelectableText.rich(TextSpan(children: children));
  }

  Widget _imageMessage(dynamic content) {
    final String url = content['url']?.toString() ?? '';
    final double imgWidth = _numToDouble(content['width'], fallback: 220);
    final double imgHeight =
        _numToDouble(content['height'], fallback: imgWidth);
    final double width = math.min(220, imgWidth <= 0 ? 220 : imgWidth);
    final double ratio = imgWidth <= 0 ? 1 : imgHeight / imgWidth;

    return InkWell(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: NetworkImgLayer(
          width: width,
          height: width * ratio,
          src: url,
        ),
      ),
    );
  }

  Widget _shareV2(BuildContext context, dynamic content, Color textColor) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final int source = _numToInt(content["source"]);
        if (source != 5) return;
        SmartDialog.showLoading(msg: '加载中');
        final String bvid = IdUtils.av2bv(int.parse(content['id'].toString()));
        final int cid = await SearchHttp.ab2c(bvid: bvid);
        final String heroTag = StringUtils.makeHeroTag(bvid);
        await SmartDialog.dismiss();

        Get.toNamed<dynamic>(
          '/video/bvid=$bvid',
          arguments: <String, String?>{
            'pic': content['thumb'],
            'heroTag': heroTag,
            'bvid': bvid,
            'cid': cid.toString(),
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 220,
              height: 220 * 9 / 16,
              child: CachedNetworkImage(
                imageUrl: content['thumb'] ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content['title'] ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (content['author'] != null) ...[
            const SizedBox(height: 1),
            Text(
              content['author'].toString(),
              style: TextStyle(
                letterSpacing: 0.6,
                height: 1.5,
                color: textColor.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _archiveCard(dynamic content, Color textColor) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        SmartDialog.showLoading(msg: '加载中');
        final bvid = content["bvid"];
        final int cid = await SearchHttp.ab2c(bvid: bvid);
        final String heroTag = StringUtils.makeHeroTag(bvid);
        SmartDialog.dismiss<dynamic>().then(
          (e) => Get.toNamed<dynamic>(
            '/video/bvid=$bvid',
            arguments: <String, String?>{
              'pic': content['thumb'] ?? '',
              'heroTag': heroTag,
              'bvid': bvid,
              'cid': cid.toString(),
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 220,
              height: 220 * 9 / 16,
              child: CachedNetworkImage(
                imageUrl: content['cover'] ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content['title'] ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            NumUtils.int2time(content['times']),
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _autoReplyPush(
    BuildContext context,
    ThemeData theme,
    dynamic content,
    Color textColor,
  ) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content['main_title'] ?? '',
              style: TextStyle(
                letterSpacing: 0.6,
                height: 1.5,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (final i in content['sub_cards'] ?? []) ...[
              const SizedBox(height: 6),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final RegExp bvRegex =
                      RegExp(r'BV[0-9A-Za-z]{10}', caseSensitive: false);
                  final Iterable<Match> matches =
                      bvRegex.allMatches(i['jump_url']);
                  if (matches.isEmpty) {
                    SmartDialog.showToast('未匹配到 BV 号');
                    Get.toNamed(
                      '/webview',
                      parameters: {
                        'url': i['jump_url'],
                        'type': 'webview',
                        'pageTitle': i['field1'] ?? '详情',
                      },
                    );
                    return;
                  }

                  try {
                    SmartDialog.showLoading(msg: '加载中');
                    final String bvid = matches.first.group(0)!;
                    final int cid = await SearchHttp.ab2c(bvid: bvid);
                    final String heroTag = StringUtils.makeHeroTag(bvid);
                    SmartDialog.dismiss<dynamic>().then(
                      (e) => Get.toNamed<dynamic>(
                        '/video/bvid=$bvid',
                        arguments: <String, String?>{
                          'pic': i['cover_url'],
                          'heroTag': heroTag,
                          'bvid': bvid,
                          'cid': cid.toString(),
                        },
                      ),
                    );
                  } catch (err) {
                    SmartDialog.dismiss();
                    SmartDialog.showToast(err.toString());
                  }
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 130,
                        height: 130 * 9 / 16,
                        child: CachedNetworkImage(
                          imageUrl: i['cover_url'] ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i['field1'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              letterSpacing: 0.6,
                              height: 1.5,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            i['field2'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              letterSpacing: 0.6,
                              height: 1.5,
                              color: textColor.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            i['field3'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              letterSpacing: 0.6,
                              height: 1.5,
                              color: textColor.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tipMessage(ThemeData theme, dynamic content) {
    String text = '';
    try {
      text = jsonDecode(content['content'])
          .map((m) => m['text'] as String)
          .join("\n");
    } catch (_) {
      text = content.toString();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          letterSpacing: 0.6,
          height: 1.5,
          color: theme.colorScheme.outline.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _systemNotice(ThemeData theme, dynamic content) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              content['title'] ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
            if ((content['text'] as String?)?.isNotEmpty == true)
              SelectableText(content['text']),
          ],
        ),
      ),
    );
  }

  Widget _pictureCard(BuildContext context, dynamic content) {
    final String? jumpUrl = content['jump_url']?.toString();
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        width: 400,
        imageUrl: content['pic_url'] ?? '',
        fit: BoxFit.cover,
      ),
    );
    if (jumpUrl != null && jumpUrl.isNotEmpty) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.toNamed(
          '/webview',
          parameters: {
            'url': jumpUrl,
            'type': 'webview',
            'pageTitle': '详情',
          },
        ),
        child: child,
      );
    }
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: child,
      ),
    );
  }

  Widget _fallbackContent(dynamic content, Color textColor, {Object? err}) {
    final String text = content != null && content != ''
        ? content is Map
            ? (content['content'] ?? content.toString()).toString()
            : content.toString()
        : '不支持的消息类型';
    return Text(
      err == null ? text : '$text\n\n$err',
      style: TextStyle(
        letterSpacing: 0.6,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

String _chatTime(dynamic timestamp) {
  final int? normalized = _normalizeTimestamp(timestamp);
  if (normalized == null || normalized == 0) return '';
  return NumUtils.dateFormat(normalized, formatType: 'detail');
}

int? _normalizeTimestamp(dynamic timestamp) {
  if (timestamp == null || timestamp == '') return null;
  final int? value = timestamp is int ? timestamp : int.tryParse('$timestamp');
  if (value == null) return null;
  return value > 1000000000000 ? value ~/ 1000 : value;
}

double _numToDouble(dynamic value, {required double fallback}) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value') ?? fallback;
}

int _numToInt(dynamic value, {int fallback = 0}) {
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? fallback;
}
