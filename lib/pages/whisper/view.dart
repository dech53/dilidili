import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/skeleton/skeleton.dart';
import 'package:dilidili/pages/whisper/controller.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhisperPage extends StatefulWidget {
  const WhisperPage({super.key});

  @override
  State<WhisperPage> createState() => _WhisperPageState();
}

class _WhisperPageState extends State<WhisperPage> {
  late final WhisperController _whisperController =
      Get.put(WhisperController());
  late Future _futureBuilderFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _whisperController.querySessionList('init');
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('my-throttler', const Duration(milliseconds: 800),
          () async {
        await _whisperController.onLoad();
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _futureBuilderFuture = _whisperController.onRefresh();
    });
    await _futureBuilderFuture;
  }

  void _openNewFans() {
    Get.toNamed(
      '/webview',
      parameters: const {
        'url': 'https://www.bilibili.com/h5/follow/newFans?navhide=1',
        'type': 'webview',
        'pageTitle': '新增粉丝',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
        actions: [
          IconButton(
            tooltip: '新增粉丝',
            onPressed: _openNewFans,
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildTopItems(padding),
            FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return _buildLoadingList();
                }

                final Map? data = snapshot.data;
                if (data == null || data['status'] != true) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(data?['msg'] ?? '请求异常'),
                    ),
                  );
                }

                return Obx(() {
                  final RxList sessionList = _whisperController.sessionList;
                  if (sessionList.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('暂无消息')),
                    );
                  }
                  return SliverPadding(
                    padding: EdgeInsets.only(bottom: padding.bottom + 24),
                    sliver: SliverList.separated(
                      itemCount: sessionList.length,
                      itemBuilder: (_, int i) {
                        return SessionItem(
                          sessionItem: sessionList[i],
                          changeFucCall: () => sessionList.refresh(),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          indent: 72,
                          endIndent: 20,
                          height: 1,
                          color: Colors.grey.withValues(alpha: 0.1),
                        );
                      },
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopItems(EdgeInsets padding) {
    return SliverPadding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      sliver: SliverToBoxAdapter(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_whisperController.noticesList.length,
                  (int index) {
                final Map item = _whisperController.noticesList[index];
                return Expanded(
                  child: _MsgFeedTopItem(
                    item: item,
                    onTap: () {
                      Get.toNamed(item['path']);
                      if (item['count'] > 0) {
                        item['count'] = 0;
                      }
                      _whisperController.noticesList.refresh();
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return SliverList.builder(
      itemCount: 12,
      itemBuilder: (context, int i) {
        final Color skeletonColor =
            Theme.of(context).colorScheme.onInverseSurface;
        return Skeleton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 14,
                        color: skeletonColor,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 13,
                        color: skeletonColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MsgFeedTopItem extends StatelessWidget {
  const _MsgFeedTopItem({
    required this.item,
    required this.onTap,
  });

  final Map item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int count = item['count'] is int ? item['count'] as int : 0;
    final IconData icon = item['icon'] as IconData;
    final String title = item['title']?.toString() ?? '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: count > 0,
              label: Text(_formatCount(count)),
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.onInverseSurface,
                child: Icon(
                  icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionItem extends StatelessWidget {
  const SessionItem({
    super.key,
    required this.sessionItem,
    required this.changeFucCall,
  });

  final Function changeFucCall;
  final dynamic sessionItem;

  bool get _isOfficial => sessionItem.officialAccount is Map;

  String get _name {
    if (_isOfficial) {
      return sessionItem.officialAccount['name']?.toString() ?? '官方消息';
    }
    return sessionItem.accountInfo?.name?.toString() ??
        sessionItem.groupName?.toString() ??
        '未知用户';
  }

  String get _avatar {
    if (_isOfficial) {
      return sessionItem.officialAccount['pic_url']?.toString() ?? '';
    }
    return sessionItem.accountInfo?.face?.toString() ??
        sessionItem.groupCover?.toString() ??
        '';
  }

  String get _summary {
    final lastMsg = sessionItem.lastMsg;
    if (lastMsg == null) return '暂无消息';
    final content = lastMsg.content;
    final int? msgStatus = lastMsg.msgStatus;
    final int? msgType = lastMsg.msgType;
    if (msgStatus == 1) return '你撤回了一条消息';
    if (msgType == 2) return '[图片]';

    if (_isOfficial && content is Map) {
      final relation = content['relation'];
      if (relation != null && relation.toString().trim().isNotEmpty) {
        return relation.toString();
      }
    }

    if (content is Map) {
      for (final String key in [
        'title',
        'text',
        'reply_content',
        'content',
      ]) {
        final value = content[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }

    if (content is String && content.trim().isNotEmpty) {
      return content;
    }
    return '不支持的消息类型';
  }

  String get _timeText {
    final int? timestamp =
        sessionItem.lastMsg?.timestamp ?? sessionItem.sessionTs;
    if (timestamp == null || timestamp == 0) return '';
    return NumUtils.dateFormat(timestamp);
  }

  bool get _isPinned => (sessionItem.topTs ?? 0) > 0;

  bool get _isMuted => (sessionItem.isDnd ?? 0) == 1;

  int get _unreadCount => sessionItem.unreadCount is int
      ? sessionItem.unreadCount as int
      : int.tryParse(sessionItem.unreadCount?.toString() ?? '') ?? 0;

  bool get _isLive => (sessionItem.liveStatus ?? 0) == 1;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: _isPinned
          ? colorScheme.onInverseSurface.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.4 : 0.75,
            )
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          sessionItem.unreadCount = 0;
          changeFucCall.call();
          final String heroTag =
              StringUtils.makeHeroTag(sessionItem.accountInfo?.mid ?? 0);
          Get.toNamed(
            '/whisperDetail',
            parameters: {
              'talkerId': sessionItem.talkerId.toString(),
              'name': _name,
              'face': _avatar,
              'mid': (sessionItem.accountInfo?.mid ?? 0).toString(),
              'heroTag': heroTag,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Badge(
                isLabelVisible: _unreadCount > 0 && !_isMuted,
                label: Text(_formatCount(_unreadCount)),
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.onInverseSurface,
                  backgroundImage: _avatar.isNotEmpty
                      ? CachedNetworkImageProvider(_avatar)
                      : null,
                  child: _avatar.isEmpty
                      ? Icon(
                          _isOfficial
                              ? Icons.notifications_none_outlined
                              : Icons.person_outline,
                          color: colorScheme.outline,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              if (_isOfficial) ...[
                                const SizedBox(width: 6),
                                const _TinyBadge(text: '官方'),
                              ],
                              if (_isLive) ...[
                                const SizedBox(width: 6),
                                const _TinyBadge(text: '直播中'),
                              ],
                            ],
                          ),
                        ),
                        if (_timeText.isNotEmpty)
                          Text(
                            _timeText,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _summary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        ),
                        if (_isMuted)
                          Icon(
                            Icons.notifications_off,
                            size: 16,
                            color: colorScheme.outline,
                          )
                        else if (_unreadCount > 0)
                          Container(
                            constraints: const BoxConstraints(minWidth: 18),
                            height: 18,
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colorScheme.error,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              _formatCount(_unreadCount),
                              style: TextStyle(
                                color: colorScheme.onError,
                                fontSize: 11,
                                height: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
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

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.45),
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 10,
          height: 1.1,
        ),
      ),
    );
  }
}

String _formatCount(int count) {
  if (count > 99) return '99+';
  return count.toString();
}
