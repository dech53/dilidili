import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/message/system.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'controller.dart';

class MessageSystemPage extends StatefulWidget {
  const MessageSystemPage({super.key});

  @override
  State<MessageSystemPage> createState() => _MessageSystemPageState();
}

class _MessageSystemPageState extends State<MessageSystemPage> {
  final MessageSystemController _messageSystemCtr =
      Get.put(MessageSystemController());
  late Future<Map> _futureBuilderFuture;

  static final RegExp _urlRegExp = RegExp(
    r'#\{([^}]*)\}\{([^}]*)\}|https?:\/\/[^\s/\$.?#].[^\s]*|www\.[^\s/\$.?#].[^\s]*|【(.*?)】|（(\d+)）',
  );

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _messageSystemCtr.queryAndProcessMessages();
  }

  Future<void> _onRefresh() async {
    final future = _messageSystemCtr.queryAndProcessMessages();
    setState(() {
      _futureBuilderFuture = future;
    });
    await future;
  }

  void _reload() {
    setState(() {
      _futureBuilderFuture = _messageSystemCtr.queryAndProcessMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          '系统通知',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(bottom: padding.bottom + 100),
              sliver: FutureBuilder<Map>(
                future: _futureBuilderFuture,
                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SliverSafeArea(
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          _buildSkeleton,
                          childCount: 12,
                        ),
                      ),
                    );
                  }

                  final Map? data = snapshot.data;
                  if (data == null || data['status'] != true) {
                    return HttpError(
                      errMsg: data?['msg'] ?? '请求异常',
                      fn: _reload,
                    );
                  }

                  return Obx(() {
                    final systemItems = _messageSystemCtr.systemItems;
                    if (systemItems.isEmpty) {
                      return const NoData();
                    }
                    return SliverList.separated(
                      itemBuilder: (context, index) => _SystemNoticeItem(
                        item: systemItems[index],
                        urlRegExp: _urlRegExp,
                      ),
                      itemCount: systemItems.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          indent: 72,
                          endIndent: 20,
                          height: 6,
                          color: Colors.grey.withValues(alpha: 0.1),
                        );
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSkeleton(BuildContext context, int index) {
  final Color color = Theme.of(context).colorScheme.onInverseSurface;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 120, height: 16, color: color),
        const SizedBox(height: 10),
        Container(width: double.infinity, height: 14, color: color),
        const SizedBox(height: 6),
        Container(
            width: MediaQuery.of(context).size.width * 0.62,
            height: 14,
            color: color),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Container(width: 96, height: 13, color: color),
        ),
      ],
    ),
  );
}

class _SystemNoticeItem extends StatelessWidget {
  const _SystemNoticeItem({
    required this.item,
    required this.urlRegExp,
  });

  final MessageSystemModel item;
  final RegExp urlRegExp;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title ?? '',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text.rich(
            _buildContent(theme, _contentText(item.content), urlRegExp),
            style: TextStyle(
              fontSize: 13.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item.timeAt ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildContent(
    ThemeData theme,
    String content,
    RegExp urlRegExp,
  ) {
    final List<InlineSpan> spanChildren = <InlineSpan>[];
    content.splitMapJoin(
      urlRegExp,
      onMatch: (Match match) {
        final String matchStr = match[0]!;
        if (matchStr.startsWith('#')) {
          try {
            final String url = match[2]!.replaceAll('"', '');
            spanChildren.add(
              TextSpan(
                text: match[1],
                style: TextStyle(color: theme.colorScheme.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _openWeb(url, match[1] ?? '详情'),
              ),
            );
          } catch (_) {
            spanChildren.add(TextSpan(text: matchStr));
          }
        } else if (matchStr.startsWith('【')) {
          try {
            final String rawId = match[3]!;
            final bool isBV = rawId.startsWith('BV');
            final String bvid = isBV ? rawId : IdUtils.av2bv(int.parse(rawId));
            spanChildren
              ..add(const TextSpan(text: '【'))
              ..add(
                TextSpan(
                  text: rawId,
                  style: TextStyle(color: theme.colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openVideo(bvid),
                ),
              )
              ..add(const TextSpan(text: '】'));
          } catch (_) {
            spanChildren.add(TextSpan(text: matchStr));
          }
        } else if (matchStr.startsWith('（')) {
          try {
            final String dynId = match[4]!;
            spanChildren
              ..add(const TextSpan(text: '（'))
              ..add(
                TextSpan(
                  text: '查看动态',
                  style: TextStyle(color: theme.colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openWeb(
                          'https://t.bilibili.com/$dynId',
                          '动态',
                        ),
                ),
              )
              ..add(const TextSpan(text: '）'));
          } catch (_) {
            spanChildren.add(TextSpan(text: matchStr));
          }
        } else {
          spanChildren.add(
            TextSpan(
              text: '🔗网页链接',
              style: TextStyle(color: theme.colorScheme.primary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _openWeb(matchStr, '网页链接'),
            ),
          );
        }
        return '';
      },
      onNonMatch: (String nonMatchStr) {
        spanChildren.add(TextSpan(text: nonMatchStr));
        return '';
      },
    );
    return TextSpan(children: spanChildren);
  }

  String _contentText(dynamic content) {
    if (content is Map) {
      return (content['web'] ?? content['content'] ?? content.toString())
          .toString()
          .trim();
    }
    return content?.toString().trim() ?? '';
  }

  void _openWeb(String url, String title) {
    Get.toNamed(
      '/webview',
      parameters: {
        'url': url,
        'type': 'webview',
        'pageTitle': title,
      },
    );
  }

  Future<void> _openVideo(String bvid) async {
    try {
      SmartDialog.showLoading(msg: '加载中');
      final int cid = await SearchHttp.ab2c(bvid: bvid);
      final String heroTag = '${bvid}_${DateTime.now().microsecondsSinceEpoch}';
      await SmartDialog.dismiss();
      Get.toNamed<dynamic>(
        '/video/bvid=$bvid',
        arguments: <String, String?>{
          'heroTag': heroTag,
          'bvid': bvid,
          'cid': cid.toString(),
        },
      );
    } catch (err) {
      await SmartDialog.dismiss();
      SmartDialog.showToast(err.toString());
    }
  }
}
