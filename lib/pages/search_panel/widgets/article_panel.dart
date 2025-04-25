import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/pages/search_panel/controller.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchArticlePanel extends StatelessWidget {
  SearchArticlePanel({
    required this.ctr,
    this.list,
    Key? key,
  }) : super(key: key);

  final SearchPanelController ctr;
  final List? list;

  final ArticlePanelController controller = Get.put(ArticlePanelController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        searchArticlePanel(context, ctr, list),
        // Container(
        //   width: double.infinity,
        //   height: 36,
        //   padding: const EdgeInsets.only(left: 8, top: 0, right: 8),
        //   child: Row(
        //     children: [
        //       Expanded(
        //           child: SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Obx(
        //           () => Wrap(
        //             children: [

        //             ],
        //           ),
        //         ),
        //       ))
        //     ],
        //   ),
        // )
      ],
    );
  }

  Widget searchArticlePanel(BuildContext context, ctr, list) {
    TextStyle textStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
        color: Theme.of(context).colorScheme.outline);
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: list!.isNotEmpty
          ? ListView.builder(
              controller: ctr!.scrollController,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        StyleString.safeSpace, 5, StyleString.safeSpace, 5),
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        final double width = (boxConstraints.maxWidth -
                                StyleString.cardSpace *
                                    6 /
                                    MediaQuery.textScalerOf(context)
                                        .scale(1.0)) /
                            2;
                        return Container(
                          constraints: const BoxConstraints(minHeight: 88),
                          height: width / StyleString.aspectRatio,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (list[index].imageUrls != null &&
                                  list[index].imageUrls.isNotEmpty)
                                AspectRatio(
                                  aspectRatio: StyleString.aspectRatio,
                                  child: LayoutBuilder(
                                      builder: (context, boxConstraints) {
                                    double maxWidth = boxConstraints.maxWidth;
                                    double maxHeight = boxConstraints.maxHeight;
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(5.r),
                                      child: CachedNetworkImage(
                                        width: maxWidth,
                                        height: maxHeight,
                                        filterQuality: FilterQuality.low,
                                        fit: BoxFit.cover,
                                        imageUrl: list[index]
                                                .imageUrls
                                                .first
                                                .startsWith('//')
                                            ? 'https:${list[index].imageUrls.first!}'
                                            : list[index].imageUrls.first!,
                                      ),
                                    );
                                  }),
                                ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 2, 6, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        maxLines: 2,
                                        text: TextSpan(
                                          children: [
                                            for (var i
                                                in list[index].title) ...[
                                              TextSpan(
                                                text: i['text'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.3,
                                                  color: i['type'] == 'em'
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                          NumUtils.dateFormat(
                                              list[index].pubTime,
                                              formatType: 'detail'),
                                          style: textStyle),
                                      Row(
                                        children: [
                                          Text('${list[index].view}浏览',
                                              style: textStyle),
                                          Text(' • ', style: textStyle),
                                          Text('${list[index].reply}评论',
                                              style: textStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
          : CustomScrollView(
              slivers: [
                HttpError(
                  errMsg: '没有数据',
                  isShowBtn: false,
                  fn: () => {},
                )
              ],
            ),
    );
  }
}

class ArticlePanelController extends GetxController {
  RxList<Map> filterList = [{}].obs;
}
