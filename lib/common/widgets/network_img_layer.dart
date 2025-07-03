import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class NetworkImgLayer extends StatelessWidget {
  const NetworkImgLayer({
    super.key,
    this.src,
    required this.width,
    required this.height,
    this.type,
    this.quality,
    this.origAspectRatio,
  });
  final double? origAspectRatio;
  final String? src;
  final double width;
  final double height;
  final String? type;
  final int? quality;

  @override
  Widget build(BuildContext context) {
    if (src == '' || src == null) {
      return placeholder(context);
    }
    final String imageUrl =
        '${src!.startsWith('//') ? 'https:${src!}' : src!}@${quality ?? 10}q.webp';
    double aspectRatio = (width / height).toDouble();
    int? memCacheWidth, memCacheHeight;
    if (aspectRatio > 1) {
      memCacheHeight =
          (height * MediaQuery.of(context).devicePixelRatio).round();
    } else if (aspectRatio < 1) {
      memCacheWidth = (width * MediaQuery.of(context).devicePixelRatio).round();
    } else {
      if (origAspectRatio != null && origAspectRatio! > 1) {
        memCacheWidth =
            (width * MediaQuery.of(context).devicePixelRatio).round();
      } else if (origAspectRatio != null && origAspectRatio! < 1) {
        memCacheHeight =
            (height * MediaQuery.of(context).devicePixelRatio).round();
      } else {
        memCacheWidth =
            (width * MediaQuery.of(context).devicePixelRatio).round();
        memCacheHeight =
            (height * MediaQuery.of(context).devicePixelRatio).round();
      }
    }
    return src != '' && src != null
        ? ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(
              type == 'avatar'
                  ? 50
                  : type == 'emote'
                      ? 0
                      :const Radius.circular(8).x,
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: width,
              height: height,
              memCacheWidth: memCacheWidth,
              memCacheHeight: memCacheHeight,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              fadeOutDuration: const Duration(milliseconds: 120),
              fadeInDuration: const Duration(milliseconds: 120),
              filterQuality: FilterQuality.low,
              errorWidget: (BuildContext context, String url, Object error) =>
                  placeholder(context),
              placeholder: (BuildContext context, String url) =>
                  placeholder(context),
            ),
          )
        : placeholder(context);
  }

  Widget placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Theme.of(context).colorScheme.onInverseSurface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(type == 'avatar'
            ? 50
            : type == 'emote'
                ? 0
                : StyleString.imgRadius.x),
      ),
      child: type == 'bg'
          ? const SizedBox()
          : Center(
              child: Image.asset(
                type == 'avatar'
                    ? 'assets/images/noface.jpeg'
                    : 'assets/images/loading.png',
                width: width,
                height: height,
                cacheWidth:
                    (width * MediaQuery.of(context).devicePixelRatio).round(),
                cacheHeight:
                    (height * MediaQuery.of(context).devicePixelRatio).round(),
              ),
            ),
    );
  }
}
