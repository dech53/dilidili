import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HtmlWidget extends StatelessWidget {
  const HtmlWidget({super.key, this.htmlContent, this.imgCount, this.imgList});
  final String? htmlContent;
  final int? imgCount;
  final List<String>? imgList;
  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlContent,
      onLinkTap: (String? url, Map<String, String> buildContext, attributes) {},
      extensions: [
        TagExtension(
          tagsToExtend: <String>{'img'},
          builder: (ExtensionContext extensionContext) {
            try {
              final Map<String, dynamic> attributes =
                  extensionContext.attributes;
              final List<dynamic> key = attributes.keys.toList();
              String imgUrl = key.contains('src')
                  ? attributes['src'] as String
                  : attributes['data-src'] as String;
              if (imgUrl.startsWith('//')) {
                imgUrl = 'https:$imgUrl';
              }
              if (imgUrl.startsWith('http://')) {
                imgUrl = imgUrl.replaceAll('http://', 'https://');
              }
              imgUrl = imgUrl.contains('@') ? imgUrl.split('@').first : imgUrl;
              final bool isEmote = imgUrl.contains('/emote/');
              final bool isMall = imgUrl.contains('/mall/');
              if (isMall) {
                return const SizedBox();
              }
              return InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(imageUrl: imgUrl),
                ),
              );
            } catch (err) {
              return const SizedBox();
            }
          },
        ),
      ],
      style: {
        'html': Style(
          fontSize: FontSize.large,
          lineHeight: LineHeight.percent(140),
        ),
        'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        'a': Style(
          color: Theme.of(context).colorScheme.primary,
          textDecoration: TextDecoration.none,
        ),
        'p': Style(
          margin: Margins.only(bottom: 10),
        ),
        'span': Style(
          fontSize: FontSize.large,
          height: Height(1.65),
        ),
        'div': Style(height: Height.auto()),
        'li > p': Style(
          display: Display.inline,
        ),
        'li': Style(
          padding: HtmlPaddings.only(bottom: 4),
          textAlign: TextAlign.justify,
        ),
        'img': Style(margin: Margins.only(top: 2, bottom: 2)),
      },
    );
  }
}
