import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/video_card_h.dart';
import 'package:dilidili/pages/search_panel/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchVideoPanel extends StatelessWidget {
  SearchVideoPanel({
    this.ctr,
    this.list,
    Key? key,
  }) : super(key: key);
  final SearchPanelController? ctr;
  final List? list;

  final VideoPanelController controller = Get.put(VideoPanelController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: list!.isNotEmpty
              ? ListView.builder(
                  controller: ctr!.scrollController,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  itemCount: list!.length,
                  itemBuilder: (context, index) {
                    var i = list![index];
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.only(top: 2)
                          : EdgeInsets.zero,
                      child: VideoCardH(
                        videoItem: i,
                        enableTap: true,
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
        ),
      ],
    );
  }
}

class VideoPanelController extends GetxController {}
