import 'package:dilidili/common/skeleton/video_card_h.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/video_card_h.dart';
import 'package:dilidili/pages/video/related/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelatedVideoPanel extends StatefulWidget {
  const RelatedVideoPanel({super.key});

  @override
  State<RelatedVideoPanel> createState() => _RelatedVideoPanelState();
}

class _RelatedVideoPanelState extends State<RelatedVideoPanel>
    with AutomaticKeepAliveClientMixin {
  late ReleatedVideoController _relatedVideoController;
  late Future _futureBuilder;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _relatedVideoController = Get.put(
      ReleatedVideoController(),
      tag: Get.arguments?['heroTag'],
    );
    _futureBuilder = _relatedVideoController
        .queryRelatedVideo()
        .catchError((e) => {'status': false, 'message': e.toString()});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _futureBuilder,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.data!['status']) {
            return SliverToBoxAdapter(
              child: Text('Error: ${snapshot.data!['message']}'),
            );
          }
          if (snapshot.data!['status'] && snapshot.data != null) {
            RxList relatedVideoList = _relatedVideoController.relatedVideoList;
            return Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    return Material(
                      child: VideoCardH(
                        videoItem: relatedVideoList[i],showPubdate: true,
                      ),
                    );
                  },
                  childCount: relatedVideoList.length,
                ),
              ),
            );
          } else {
            return HttpError(errMsg: '出错了', fn: () {});
          }
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return const VideoCardHSkeleton();
            }, childCount: 5),
          );
        }
      },
    );
  }
}
