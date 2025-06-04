import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget picWidget(item, context, floor) {
  String type = item.modules.moduleDynamic.major.type;
  List pictures = [];
  if (type == 'MAJOR_TYPE_DRAW' ) {
    pictures = item.modules.moduleDynamic.major.draw.items;
  }
  int len = pictures.length;
  List<String> picList = [];
  List<Widget> list = [];
  for (var i = 0; i < len; i++) {
    picList.add(pictures[i].src ?? pictures[i].url);
  }
  for (var i = 0; i < len; i++) {
    list.add(
      LayoutBuilder(
        builder: (context, BoxConstraints box) {
          return Hero(
            tag: picList[i],
            placeholderBuilder:
                (BuildContext context, Size heroSize, Widget child) {
              return child;
            },
            child: GestureDetector(
              onTap: () {},
              child: NetworkImgLayer(
                src: pictures[i].src,
                width: box.maxWidth,
                height: box.maxWidth,
              ),
            ),
          );
        },
      ),
    );
  }
  return LayoutBuilder(
    builder: (context, BoxConstraints box) {
      double maxWidth = box.maxWidth;
      double aspectRatio = 1.0;
      double origAspectRatio = 0.0;
      double crossCount = 3;

      double height = 0.0;
      if (len == 1) {
        try {
          origAspectRatio =
              aspectRatio = pictures.first.width / pictures.first.height;
        } catch (_) {}
        if (aspectRatio < 0.4) {
          aspectRatio = 0.4;
        }
        if (origAspectRatio < 0.5 || pictures.first.width < 1920) {
          crossCount = 2;
          height = maxWidth / 2 / aspectRatio;
        }
      } else {
        aspectRatio = 1;
        height =
            maxWidth / crossCount * ((len + crossCount - 1) ~/ crossCount) + 6;
      }
      return Container(
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(StyleString.imgRadius.x),
        ),
        clipBehavior: Clip.hardEdge,
        height: height,
        child: Stack(
          children: [
            GridView.count(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossCount.toInt(),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: aspectRatio,
              children: list,
            ),
            if (len == 1 && height > Get.size.height * 0.9)
              const PBadge(
                text: '长图',
                top: null,
                right: null,
                bottom: 6.0,
                left: 6.0,
                type: 'gray',
              )
          ],
        ),
      );
    },
  );
}
