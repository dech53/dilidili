import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/skeleton/video_card_h.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/pages/favorite/controller.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin {
  late FavoriteController _favoriteController ;
  late Future _futureBuilder;late int mid;

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.arguments['mid']!);
    _favoriteController = Get.put(FavoriteController(), tag: mid.toString());
    _futureBuilder = _favoriteController.queryFavFolder();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _futureBuilder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map? data = snapshot.data;
          if (data != null && data['status']) {
            if (_favoriteController.favFolderList.isNotEmpty) {
              return Obx(
                () => CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) {
                          if (index >=
                              _favoriteController.favFolderList.length - 2) {
                            EasyThrottle.throttle(
                                'history', const Duration(seconds: 1), () {
                              _favoriteController.onLoad();
                            });
                          }
                          return FavItem(
                            favFolderItem:
                                _favoriteController.favFolderList[index],
                            isOwner: _favoriteController.isOwner.value,
                          );
                        },
                        childCount: _favoriteController.favFolderList.length,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  HttpError(
                    errMsg: '用户没有公开收藏夹',
                    fn: () {
                      setState(
                        () {
                          _futureBuilder = _favoriteController.queryFavFolder();
                        },
                      );
                    },
                  ),
                ],
              );
            }
          } else {
            return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                HttpError(
                  errMsg: data?['msg'] ?? '请求异常',
                  btnText: data?['code'] == -101 ? '去登录' : null,
                  fn: () {
                    setState(
                      () {
                        _futureBuilder = _favoriteController.queryFavFolder();
                      },
                    );
                  },
                ),
              ],
            );
          }
        } else {
          // 骨架屏
          return CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    return const VideoCardHSkeleton();
                  },
                  childCount: 5,
                ),
              )
            ],
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FavItem extends StatelessWidget {
  final favFolderItem;
  final bool isOwner;
  const FavItem(
      {super.key, required this.favFolderItem, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    String heroTag = StringUtils.makeHeroTag(favFolderItem.fid);
    return InkWell(
      onTap: () async {
        //跳转收藏夹详情
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
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
                        return Hero(
                          tag: heroTag,
                          child: NetworkImgLayer(
                            src: favFolderItem.cover,
                            width: maxWidth,
                            height: maxHeight,
                          ),
                        );
                      },
                    ),
                  ),
                  VideoContent(favFolderItem: favFolderItem)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  final dynamic favFolderItem;
  const VideoContent({super.key, required this.favFolderItem});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 6, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favFolderItem.title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '${favFolderItem.mediaCount}个内容',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const Spacer(),
            Text(
              [23, 1].contains(favFolderItem.attr) ? '私密' : '公开',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
