import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FowardPic extends StatefulWidget {
  FowardPic({super.key, this.item});
  dynamic item;
  @override
  State<FowardPic> createState() => _FowardPicState();
}

class _FowardPicState extends State<FowardPic> {
  late bool hasPics;
  List<DynamicDrawItemModel> pics = [];

  @override
  void initState() {
    super.initState();
    hasPics = widget.item.modules.moduleDynamic.major != null &&
        widget.item.modules.moduleDynamic.major.draw != null &&
        widget.item.modules.moduleDynamic.major.draw.items.isNotEmpty;
    if (hasPics) {
      pics = widget.item.modules.moduleDynamic.major.draw.items;
    }
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
              double maxWidth = box.maxWidth;
              double maxHeight = box.maxWidth;
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
                  onTap: () {},
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
              return Hero(
                tag: picList[i],
                child: GestureDetector(
                  onTap: () {},
                  child: NetworkImgLayer(
                    src: pics[i].src,
                    width: maxWidth,
                    height: maxWidth,
                    origAspectRatio:
                        pics[i].width!.toInt() / pics[i].height!.toInt(),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasPics) ...[
            Text.rich(picsNodes()),
          ],
        ],
      ),
    );
  }
}
