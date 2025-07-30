import 'package:dilidili/model/video/video_tag.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class IntroDetail extends StatelessWidget {
  const IntroDetail({
    super.key,
    this.videoDetail,
    this.videoTags,
  });
  final dynamic videoDetail;
  final List<VideoTag>? videoTags;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 4),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: videoDetail!.bvid!));
                  SmartDialog.showToast('已复制');
                },
                child: Text(
                  videoDetail!.bvid!,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: videoDetail!.aid!.toString()));
                  SmartDialog.showToast('已复制');
                },
                child: Text(
                  videoDetail!.aid!.toString(),
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary),
                ),
              )
            ],
          ),
          if (videoDetail?.desc != "") ...[
            const SizedBox(height: 4),
            SelectableRegion(
              focusNode: FocusNode(),
              selectionControls: MaterialTextSelectionControls(),
              child: Text.rich(
                style: const TextStyle(height: 1.4),
                TextSpan(
                  children: [
                    buildContent(context, videoDetail!),
                  ],
                ),
              ),
            ),
          ],
          // 视频标签展示
          if (videoTags != null && videoTags!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: videoTags!.map((tag) {
                return InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Get.toNamed('/searchResult',
                        parameters: {'keyword': tag.tagName!});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      tag.tagName ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .color!
                            .withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }

  InlineSpan buildContent(BuildContext context, content) {
    final List descV2 = content.descV2;
    // type
    // 1 普通文本
    // 2 @用户
    final List<TextSpan> spanChilds = List.generate(descV2.length, (index) {
      final currentDesc = descV2[index];
      switch (currentDesc.type) {
        case 1:
          final List<InlineSpan> spanChildren = <InlineSpan>[];
          final RegExp urlRegExp = RegExp(r'https?://\S+\b');
          final Iterable<Match> matches =
              urlRegExp.allMatches(currentDesc.rawText);

          int previousEndIndex = 0;
          for (final Match match in matches) {
            if (match.start > previousEndIndex) {
              spanChildren.add(TextSpan(
                  text: currentDesc.rawText
                      .substring(previousEndIndex, match.start)));
            }
            spanChildren.add(
              TextSpan(
                text: match.group(0),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary), // 设置颜色为蓝色
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // 处理点击事件
                    try {
                      Get.toNamed(
                        '/webview',
                        parameters: {
                          'url': match.group(0)!,
                          'type': 'url',
                          'pageTitle': match.group(0)!,
                        },
                      );
                    } catch (err) {
                      SmartDialog.showToast(err.toString());
                    }
                  },
              ),
            );
            previousEndIndex = match.end;
          }

          if (previousEndIndex < currentDesc.rawText.length) {
            spanChildren.add(TextSpan(
                style: TextStyle(fontSize: 12,
                  color: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .color!
                      .withOpacity(0.7),
                ),
                text: currentDesc.rawText.substring(previousEndIndex)));
          }

          final TextSpan result = TextSpan(children: spanChildren);
          return result;
        case 2:
          final Color colorSchemePrimary =
              Theme.of(context).colorScheme.primary;
          final String heroTag = StringUtils.makeHeroTag(currentDesc.bizId);
          return TextSpan(
            text: '@${currentDesc.rawText}',
            style: TextStyle(color: colorSchemePrimary),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(
                  '/member?mid=${currentDesc.bizId}',
                  arguments: {
                    'face': videoDetail!.owner!.face!,
                    'heroTag': heroTag,
                  },
                );
              },
          );
        default:
          return const TextSpan();
      }
    });
    return TextSpan(children: spanChilds);
  }
}
