import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/http/user.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/utils/image_save.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class VideoCardComponent extends StatelessWidget {
  final RcmdVideoItem video;
  final Function? blockUserCb;
  final Function(RcmdVideoItem video)? itemTap;
  const VideoCardComponent({
    required this.video,
    super.key,
    this.itemTap,
    this.blockUserCb,
  });
  void onPushDetail() async {
    String goto = video.goto;
    switch (goto) {
      case 'av':
        Get.toNamed(
          '/video/bvid=${video.bvid}',
          arguments: {
            'heroTag': StringUtils.makeHeroTag(video.id),
            'bvid': video.bvid,
            'cid': video.cid.toString(),
          },
        );
        break;
      // 动态
      case 'picture':
        try {
          Get.toNamed('/read', parameters: {
            'title': video.title,
            'id': video.id.toString(),
            'articleType': 'read'
          });
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;
      default:
        SmartDialog.showToast(video.goto);
        Get.toNamed(
          '/webview',
          parameters: {
            'url': video.uri,
            'type': 'url',
            'pageTitle': video.title,
          },
        );
    }
  }

  Widget _buildBadge(String text, String type, [double fs = 12]) {
    return PBadge(
      text: text,
      stack: 'normal',
      size: 'small',
      type: type,
      fs: fs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => onPushDetail(),
      onLongPress: () => imageSaveDialog(
        context,
        video,
        SmartDialog.dismiss,
      ),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: StyleString.aspectRatio,
            child: LayoutBuilder(builder: (context, boxConstraints) {
              double maxWidth = boxConstraints.maxWidth;
              double maxHeight = boxConstraints.maxHeight;
              return Stack(
                children: [
                  NetworkImgLayer(
                    src: video.pic,
                    width: maxWidth,
                    height: maxHeight,
                  ),
                  if (video.duration > 0)
                    PBadge(
                      bottom: 6,
                      right: 7,
                      type: 'gray',
                      text: NumUtils.int2time(video.duration),
                    ),
                  if (video.rcmd_reason != null &&
                      video.rcmd_reason!.content != null)
                    PBadge(
                      top: 8,
                      left: 8,
                      text: video.rcmd_reason!.content!,
                    )
                ],
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          NumUtils.int2Num(video.stat.view),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.subtitles_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          NumUtils.int2Num(video.stat.danmaku),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    RichText(
                      maxLines: 1,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        text: NumUtils.formatTimestampToRelativeTime(
                          video.pubdate,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                Row(
                  children: [
                    if (video.goto == 'picture') _buildBadge('动态', 'line', 9),
                    if (video.is_followed == 1) _buildBadge('已关注', 'color'),
                    Expanded(
                      flex: 1,
                      child: Text(
                        video.owner.name,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium!.fontSize,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    if (video.goto == 'av')
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              builder: (context) {
                                return MorePanel(
                                  videoItem: video,
                                  blockUserCb: blockUserCb,
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.more_vert_outlined,
                            color: Theme.of(context).colorScheme.outline,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MorePanel extends StatelessWidget {
  final dynamic videoItem;
  final Function? blockUserCb;
  const MorePanel({
    super.key,
    required this.videoItem,
    this.blockUserCb,
  });

  Future<dynamic> menuActionHandler(String type) async {
    switch (type) {
      case 'block':
        Get.back();
        blockUser();
        break;
      case 'watchLater':
        var res = await UserHttp.toViewLater(bvid: videoItem.bvid as String);
        SmartDialog.showToast(res['msg']);
        Get.back();
        break;
      default:
    }
  }

  void blockUser() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text('确定拉黑:${videoItem.owner.name}(${videoItem.owner.mid})?'
              '\n\n注：被拉黑的Up可以在隐私设置-黑名单管理中解除'),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                var res = await VideoHttp.relationMod(
                  mid: videoItem.owner.mid,
                  act: 5,
                  reSrc: 11,
                );
                SmartDialog.dismiss();
                if (res['status']) {
                  blockUserCb?.call(videoItem.owner.mid);
                }
                SmartDialog.showToast(res['msg']);
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () async => await menuActionHandler('block'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.block, size: 19),
            title: Text(
              '拉黑up主 「${videoItem.owner.name}」',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListTile(
            onTap: () async => await menuActionHandler('watchLater'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.watch_later_outlined, size: 19),
            title:
                Text('添加至稍后再看', style: Theme.of(context).textTheme.titleSmall),
          ),
          ListTile(
            onTap: () =>
                imageSaveDialog(context, videoItem, SmartDialog.dismiss),
            minLeadingWidth: 0,
            leading: const Icon(Icons.photo_outlined, size: 19),
            title:
                Text('查看视频封面', style: Theme.of(context).textTheme.titleSmall),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
