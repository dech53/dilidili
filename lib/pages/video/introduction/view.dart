import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/pages/video/introduction/controller.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VideoIntroPanel extends StatefulWidget {
  final String bvid;
  final String? cid;

  const VideoIntroPanel({super.key, required this.bvid, this.cid});

  @override
  State<VideoIntroPanel> createState() => _VideoIntroPanelState();
}

class _VideoIntroPanelState extends State<VideoIntroPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late VideoIntroController videoIntroController;
  late Future? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    videoIntroController = Get.put(
      VideoIntroController(bvid: widget.bvid),
    );
    _futureBuilderFuture = videoIntroController.queryVideoIntro();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const SliverToBoxAdapter(child: SizedBox());
          }
          if (snapshot.data['status']) {
            // 请求成功
            return SliverToBoxAdapter(
              child: VideoInfo(
                bvid: widget.bvid,
                videoDetail: videoIntroController.videoDetail.value,
                userInfo: videoIntroController.userInfo.value,
              ),
            );
          } else {
            // 请求错误
            return HttpError(
              errMsg: snapshot.data['msg'],
              btnText: snapshot.data['code'] == -404 ||
                      snapshot.data['code'] == 62002
                  ? '返回上一页'
                  : null,
              fn: () => Get.back(),
            );
          }
        } else {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: Center(
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 200,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class VideoInfo extends StatefulWidget {
  final VideoDetailData? videoDetail;
  final String bvid;
  final UserCardInfo? userInfo;
  const VideoInfo({
    Key? key,
    this.videoDetail,
    required this.bvid,
    this.userInfo,
  }) : super(key: key);

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          //点击用户头像
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          widget.videoDetail!.owner!.face),
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.videoDetail!.owner!.name,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                        2.verticalSpace,
                        Row(
                          children: [
                            Text(
                              "${NumUtils.int2Num(widget.userInfo!.follower!)}粉丝",
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              "${NumUtils.int2Num(widget.userInfo!.archiveCount!)}视频",
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 32,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      foregroundColor: (widget.userInfo!.following!)
                          ? Theme.of(context).colorScheme.outline
                          : Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: (widget.userInfo!.following!)
                          ? Theme.of(context).colorScheme.onInverseSurface
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      (widget.userInfo!.following!) ? '已关注' : '关注',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        //标题
        Text(
          widget.videoDetail!.title!,
          overflow: TextOverflow.ellipsis,
        ),
        //视频数据
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.grey,
              size: 14,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              NumUtils.int2Num(widget.videoDetail!.stat!.view),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(
              width: 8,
            ),
            const Icon(
              Icons.subtitles_outlined,
              color: Colors.grey,
              size: 14,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              NumUtils.int2Num(widget.videoDetail!.stat!.danmaku),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        )
      ],
    );
  }
}
