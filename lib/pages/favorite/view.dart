import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/skeleton/video_card_h.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/pages/favorite/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin {
  final FavoriteController _favoriteController = Get.put(FavoriteController());
  late Future _futureBuilder;

  @override
  void initState() {
    super.initState();
    _futureBuilder = _favoriteController.getUserFolderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: CustomScrollView(
          controller: _favoriteController.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              sliver: FutureBuilder(
                future: _futureBuilder,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () => SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: LayoutBuilder(
                                        builder: (context, boxConstraints) {
                                          double width = (boxConstraints
                                                      .maxWidth -
                                                  StyleString.cardSpace * 6) /
                                              2;
                                          return SizedBox(
                                            height:
                                                width / StyleString.aspectRatio,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio:
                                                      StyleString.aspectRatio,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // 设置圆角大小
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          _favoriteController
                                                              .favoriteInfos[
                                                                  index]
                                                              .cover!,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8), // 确保占位图也有圆角
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(
                                                        Icons.error,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                VideoContent(
                                                  favFolderItem:
                                                      _favoriteController
                                                          .favoriteInfos[index],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: _favoriteController.favorites.length,
                          ),
                        ),
                      );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () {},
                      );
                    }
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: VideoCardHSkeleton(),
                        );
                      }, childCount: 6),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoContent extends StatelessWidget {
  final dynamic favFolderItem;
  const VideoContent({super.key, required this.favFolderItem});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 6, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favFolderItem.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                letterSpacing: 0.3,
                color: Theme.of(context).textTheme.titleMedium!.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${favFolderItem.mediaCount}个内容',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const Spacer(),
            Text(
              [23, 1].contains(favFolderItem.attr) ? '私密' : '公开',
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
