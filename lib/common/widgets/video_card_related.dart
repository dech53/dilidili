import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class VideoCardRelated extends StatelessWidget {
  final RelatedVideoItem relatedVideoItem;
  const VideoCardRelated({super.key, required this.relatedVideoItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          
        },
        child: SizedBox(
          width: ScreenUtil().screenWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //封面图片
              Container(
                width: 160.w,
                height: 90.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: relatedVideoItem.pic!
                              .replaceFirst("http://", "https://"),
                          httpHeaders: const {},
                        ),
                      ),
                    ),
                    Positioned(
                      right: 3.0,
                      bottom: 3.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: Text(
                            NumUtils.int2time(relatedVideoItem.duration!),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              7.horizontalSpace,
              //标题、作者、日期
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      relatedVideoItem.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    2.verticalSpace,
                    Text(
                      NumUtils.dateFormat(relatedVideoItem.pubdate!),
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline),
                    ),
                    2.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          LineIcons.user,
                          size: 16,
                          color: Colors.grey,
                        ),
                        2.horizontalSpace,
                        Text(
                          relatedVideoItem.owner!.name!,
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          NumUtils.int2Num(
                            relatedVideoItem.stat!['view']!,
                          ),
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
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
                          NumUtils.int2Num(
                            relatedVideoItem.stat!['danmaku']!,
                          ),
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
