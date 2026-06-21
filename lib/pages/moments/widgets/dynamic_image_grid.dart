import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/pages/gallery/preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicImageGrid extends StatelessWidget {
  const DynamicImageGrid({
    super.key,
    required this.pictures,
  });

  final List pictures;

  String? _url(dynamic item) => item?.url ?? item?.src;

  num? _width(dynamic item) => item?.width;

  num? _height(dynamic item) => item?.height;

  @override
  Widget build(BuildContext context) {
    final urls = pictures
        .map(_url)
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList();
    if (urls.isEmpty) {
      return const SizedBox.shrink();
    }

    final len = urls.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        int crossCount = len < 3 ? len : 3;
        double childAspectRatio = 1;
        double height;

        if (len == 1) {
          final pic = pictures.first;
          final width = _width(pic);
          final picHeight = _height(pic);
          double ratio = 1;
          if (width != null && picHeight != null && picHeight != 0) {
            ratio = width / picHeight;
          }
          ratio = ratio.clamp(0.42, 2.4).toDouble();
          crossCount = ratio > 1.2 ? 1 : 2;
          childAspectRatio = ratio;
          height = maxWidth / crossCount / childAspectRatio;
        } else {
          final rows = (len / crossCount).ceil();
          height = (maxWidth - (crossCount - 1) * 4) / crossCount * rows +
              (rows - 1) * 4;
        }

        return Container(
          margin: const EdgeInsets.only(top: 6),
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Stack(
            children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: len,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  final url = urls[index];
                  final pic = pictures[index];
                  final width = _width(pic);
                  final picHeight = _height(pic);
                  return Hero(
                    tag: url,
                    child: GestureDetector(
                      onTap: () => openGalleryPreview(
                        context,
                        sources: urls,
                        initIndex: index,
                      ),
                      child: NetworkImgLayer(
                        src: url,
                        width: maxWidth,
                        height: maxWidth,
                        origAspectRatio:
                            width != null && picHeight != null && picHeight != 0
                                ? width / picHeight
                                : null,
                      ),
                    ),
                  );
                },
              ),
              if (len == 1 && height > Get.size.height * 0.9)
                const PBadge(
                  text: '长图',
                  type: 'gray',
                  right: 6,
                  bottom: 6,
                ),
            ],
          ),
        );
      },
    );
  }
}
