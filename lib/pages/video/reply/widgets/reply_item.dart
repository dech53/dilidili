import 'package:dilidili/common/reply_type.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/reply/item.dart';
import 'package:dilidili/pages/video/reply/widgets/zan.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyItem extends StatelessWidget {
  const ReplyItem({
    this.replyItem,
    this.addReply,
    this.replyLevel,
    this.showReplyRow = true,
    this.replyReply,
    this.replyType,
    this.replySave = false,
    super.key,
  });
  final ReplyItemModel? replyItem;
  final Function? addReply;
  final String? replyLevel;
  final bool? showReplyRow;
  final Function? replyReply;
  final ReplyType? replyType;
  final bool? replySave;

  @override
  Widget build(BuildContext context) {
    final bool isOwner =
        int.parse(replyItem!.member!.mid!) == (SPStorage.userID ?? -1);
    return Material(
      child: InkWell(
        onTap: () {},
        onLongPress: () {},
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 14, 8, 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Theme.of(context)
                    .colorScheme
                    .onInverseSurface
                    .withOpacity(0.5),
              ),
            ),
          ),
          child: content(context),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    final String heroTag = StringUtils.makeHeroTag(replyItem!.mid);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Get.toNamed('/member/mid=${replyItem!.mid}', arguments: {
              'face': replyItem!.member!.avatar!,
              'heroTag': heroTag,
              'mid': replyItem!.member!.mid.toString(),
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: heroTag,
                    child: NetworkImgLayer(
                      src: replyItem!.member!.avatar,
                      width: 34,
                      height: 34,
                      type: 'avatar',
                    ),
                  ),
                  if (replyItem!.member!.officialVerify != null &&
                      replyItem!.member!.officialVerify!['type'] == 0)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: colorScheme.surface,
                        ),
                        child: Icon(
                          Icons.offline_bolt,
                          color: colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ),
                  if (replyItem!.member!.vip!['vipStatus'] > 0 &&
                      replyItem!.member!.vip!['vipType'] == 2)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: colorScheme.background,
                        ),
                        child: Image.asset(
                          'assets/images/big-vip.png',
                          height: 14,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        replyItem!.member!.uname!,
                        style: TextStyle(
                          color: replyItem!.member!.vip!['vipStatus'] > 0
                              ? const Color.fromARGB(255, 251, 100, 163)
                              : colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Image.asset(
                          'assets/images/lv/lv${replyItem!.member!.level}.png',
                          height: 11,
                        ),
                      ),
                      if (replyItem!.isUp!)
                        const PBadge(
                          text: 'UP',
                          size: 'small',
                          stack: 'normal',
                          fs: 9,
                        ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumUtils.dateFormat(replyItem!.ctime),
                          style: TextStyle(
                            fontSize: textTheme.labelSmall!.fontSize,
                            color: colorScheme.outline,
                          ),
                        ),
                        if (replyItem!.replyControl != null &&
                            replyItem!.replyControl!.location != '')
                          TextSpan(
                            text: ' • ${replyItem!.replyControl!.location!}',
                            style: TextStyle(
                              fontSize: textTheme.labelSmall!.fontSize,
                              color: colorScheme.outline,
                            ),
                          ),
                        if (replyItem!.invisible!)
                          TextSpan(
                            text: ' • 隐藏的评论',
                            style: TextStyle(
                              color: colorScheme.outline,
                              fontSize: textTheme.labelSmall!.fontSize,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, left: 45, right: 6, bottom: 4),
          child: Text.rich(
            style: const TextStyle(height: 1.75),
            maxLines:
                replyItem!.content!.isText! && replyLevel == '1' ? 3 : 999,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              children: [
                if (replyItem!.isTop!)
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: PBadge(
                      text: 'TOP',
                      size: 'small',
                      stack: 'normal',
                      type: 'line',
                      fs: 9,
                    ),
                  ),
                TextSpan(text: replyItem!.content!.message),
              ],
            ),
          ),
        ),
        bottonAction(context, replyItem!.replyControl, replySave),
      ],
    );
  }

  // 感谢、回复、复制
  Widget bottonAction(BuildContext context, replyControl, replySave) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        const SizedBox(width: 32),
        SizedBox(
          height: 32,
          child: TextButton(
            onPressed: () {},
            child: Row(
              children: [
                if (!replySave!) ...[
                  Icon(Icons.reply,
                      size: 18, color: colorScheme.outline.withOpacity(0.8)),
                  const SizedBox(width: 3),
                  Text(
                    '回复',
                    style: TextStyle(
                      fontSize: textTheme.labelMedium!.fontSize,
                      color: colorScheme.outline,
                    ),
                  )
                ],
                if (replySave!)
                  Text(
                    IdUtils.av2bv(replyItem!.oid!),
                    style: TextStyle(
                      fontSize: textTheme.labelMedium!.fontSize,
                      color: colorScheme.outline,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 2),
        if (replyItem!.upAction!.like!) ...[
          Text(
            'up主觉得很赞',
            style: TextStyle(
                color: colorScheme.primary,
                fontSize: textTheme.labelMedium!.fontSize),
          ),
          const SizedBox(width: 2),
        ],
        if (replyItem!.cardLabel!.isNotEmpty &&
            replyItem!.cardLabel!.contains('热评'))
          Text(
            '热评',
            style: TextStyle(
                color: colorScheme.primary,
                fontSize: textTheme.labelMedium!.fontSize),
          ),
        const Spacer(),
        ZanButton(replyItem: replyItem, replyType: replyType),
        const SizedBox(width: 5)
      ],
    );
  }
}
