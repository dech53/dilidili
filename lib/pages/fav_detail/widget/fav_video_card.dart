import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/common/widgets/stat/danmu.dart';
import 'package:dilidili/common/widgets/stat/view.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/image_save.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/badge.dart';

// 收藏视频卡片 - 水平布局
class FavVideoCardH extends StatelessWidget {
  final dynamic videoItem;
  final Function? callFn;
  final int? searchType;
  final String isOwner;

  const FavVideoCardH({
    Key? key,
    required this.videoItem,
    this.callFn,
    this.searchType,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id;
    String bvid = videoItem.bvid ?? IdUtils.av2bv(id);
    String heroTag = StringUtils.makeHeroTag(id);
    return InkWell(
      onTap: () async {
        
      },
      onLongPress: () => imageSaveDialog(
        context,
        videoItem,
        SmartDialog.dismiss,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.safeSpace, 5, StyleString.safeSpace, 5),
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                double width =
                    (boxConstraints.maxWidth - StyleString.cardSpace * 6) / 2;
                return SizedBox(
                  height: width / StyleString.aspectRatio,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: StyleString.aspectRatio,
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            double maxWidth = boxConstraints.maxWidth;
                            double maxHeight = boxConstraints.maxHeight;
                            return Stack(
                              children: [
                                Hero(
                                  tag: heroTag,
                                  child: NetworkImgLayer(
                                    src: videoItem.pic,
                                    width: maxWidth,
                                    height: maxHeight,
                                  ),
                                ),
                                PBadge(
                                  text:
                                      NumUtils.dateFormat(videoItem.duration!),
                                  right: 6.0,
                                  bottom: 6.0,
                                  type: 'gray',
                                ),
                                if (videoItem.ogv != null) ...[
                                  PBadge(
                                    text: videoItem.ogv['type_name'],
                                    top: 6.0,
                                    right: 6.0,
                                    bottom: null,
                                    left: null,
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                      VideoContent(
                        videoItem: videoItem,
                        callFn: callFn,
                        searchType: searchType,
                        isOwner: isOwner,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  final dynamic videoItem;
  final Function? callFn;
  final int? searchType;
  final String isOwner;
  const VideoContent({
    super.key,
    required this.videoItem,
    this.callFn,
    this.searchType,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 6, 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoItem.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (videoItem.ogv != null) ...[
                  Text(
                    videoItem.intro,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  NumUtils.dateFormat(videoItem.favTime),
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.outline),
                ),
                if (videoItem.owner.name != '') ...[
                  Text(
                    videoItem.owner.name,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      StatView(view: videoItem.cntInfo['play']),
                      const SizedBox(width: 8),
                      StatDanMu(danmu: videoItem.cntInfo['danmaku']),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
            searchType != 1 && isOwner == '1'
                ? Positioned(
                    right: 0,
                    bottom: -4,
                    child: IconButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {
                        showDialog(
                          context: Get.context!,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('提示'),
                              content: const Text('要取消收藏吗?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      '取消',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                    )),
                                TextButton(
                                  onPressed: () async {
                                    await callFn!();
                                    Get.back();
                                  },
                                  child: const Text('确定取消'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.clear_outlined,
                        color: Theme.of(context).colorScheme.outline,
                        size: 18,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
