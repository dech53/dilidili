import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/gallery/gallery_viewer.dart';
import 'package:dilidili/pages/gallery/hero_route.dart';
import 'package:dilidili/pages/moments/widgets/rich_node_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Content extends StatefulWidget {
  dynamic item;
  String? source;
  Content({
    super.key,
    this.item,
    this.source,
  });

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  late bool hasPics;
  late bool hasCovers;
  List<DynamicDrawItemModel> pics = [];
  @override
  void initState() {
    super.initState();
    hasPics = widget.item.modules.moduleDynamic.major != null &&
        widget.item.modules.moduleDynamic.major.draw != null &&
        widget.item.modules.moduleDynamic.major.draw.items.isNotEmpty;
    hasCovers = widget.item.modules!.moduleDynamic!.major != null &&
        widget.item.modules.moduleDynamic.major.type == 'MAJOR_TYPE_ARTICLE' &&
        widget.item.modules.moduleDynamic.major.article.covers != null;
    if (hasPics) {
      pics = widget.item.modules.moduleDynamic.major.draw.items;
    }
    if (hasCovers) {
      for (var i in widget.item.modules.moduleDynamic.major.article.covers) {
        pics.add(DynamicDrawItemModel(src: i.toString()));
      }
    }
  }

  void onPreviewImg(picList, initIndex, context) {
    Navigator.of(context).push(
      HeroRoute<void>(
        builder: (BuildContext context) => GalleryViewer(
          sources: picList,
          initIndex: initIndex,
          onPageChanged: (int pageIndex) {},
        ),
      ),
    );
  }

  InlineSpan picsNodes() {
    List<InlineSpan> spanChilds = [];
    int len = pics.length;
    List<String> picList = [];

    if (len == 1) {
      DynamicDrawItemModel pictureItem = pics.first;
      picList.add(pictureItem.src!);
      spanChilds.add(
        WidgetSpan(
          child: LayoutBuilder(
            builder: (context, BoxConstraints box) {
              double maxWidth = box.maxWidth.truncateToDouble();
              double maxHeight = box.maxWidth * 0.6;
              double height = maxWidth *
                  0.5 *
                  (pictureItem.height != null && pictureItem.width != null
                      ? pictureItem.height! / pictureItem.width!
                      : 9 / 16);
              return Hero(
                tag: pictureItem.src!,
                placeholderBuilder:
                    (BuildContext context, Size heroSize, Widget child) {
                  return child;
                },
                child: GestureDetector(
                  onTap: () => onPreviewImg(picList, 1, context),
                  child: Container(
                    padding: const EdgeInsets.only(top: 4),
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    width: box.maxWidth / 2,
                    height: height,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: NetworkImgLayer(
                            src: pictureItem.src,
                            width: maxWidth / 2,
                            height: height,
                          ),
                        ),
                        height > Get.size.height * 0.9
                            ? const PBadge(
                                text: '长图',
                                right: 8,
                                bottom: 8,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    if (len > 1) {
      List<Widget> list = [];
      for (var i = 0; i < len; i++) {
        picList.add(pics[i].src!);
      }
      for (var i = 0; i < len; i++) {
        list.add(
          LayoutBuilder(
            builder: (context, BoxConstraints box) {
              double maxWidth = box.maxWidth.truncateToDouble();
              double height = maxWidth *
                  (pics[i].height != null && pics[i].width != null
                      ? pics[i].height! / pics[i].width!
                      : 9 / 16);
              return Hero(
                tag: picList[i],
                child: GestureDetector(
                  onTap: () => onPreviewImg(picList, i, context),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: NetworkImgLayer(
                          src: pics[i].src,
                          width: maxWidth,
                          height: height,
                          origAspectRatio:
                              pics[i].width!.toInt() / pics[i].height!.toInt(),
                        ),
                      ),
                      if (pics[i].height!.toInt() / pics[i].width!.toInt() > 2)
                        const PBadge(
                          text: '长图',
                          top: null,
                          right: 6.0,
                          bottom: 6.0,
                          left: null,
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
      spanChilds.add(
        WidgetSpan(
          child: LayoutBuilder(
            builder: (context, BoxConstraints box) {
              double maxWidth = box.maxWidth.truncateToDouble();
              double crossCount = len < 3 ? 2 : 3;
              double height = maxWidth /
                      crossCount *
                      (len % crossCount == 0
                          ? len ~/ crossCount
                          : len ~/ crossCount + 1) +
                  6;
              return Container(
                padding: const EdgeInsets.only(top: 6),
                height: height,
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossCount.toInt(),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 1,
                  children: list,
                ),
              );
            },
          ),
        ),
      );
    }
    return TextSpan(
      children: spanChilds,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle authorStyle =
        TextStyle(color: Theme.of(context).colorScheme.primary);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.item.modules.moduleDynamic.topic != null) ...[
            GestureDetector(
              child: Text(
                '#${widget.item.modules.moduleDynamic.topic.name}',
                style: authorStyle,
              ),
            ),
          ],
          IgnorePointer(
            ignoring: widget.source == 'detail' ? false : true,
            child: SelectableRegion(
              magnifierConfiguration: const TextMagnifierConfiguration(),
              focusNode: FocusNode(),
              selectionControls: MaterialTextSelectionControls(),
              child: Text.rich(
                style: const TextStyle(height: 0),
                richNode(widget.item, context),
                maxLines: widget.source == 'detail' ? 999 : 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (hasPics || hasCovers) ...[Text.rich(picsNodes())],
        ],
      ),
    );
  }
}
