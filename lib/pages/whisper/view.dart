import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
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

  Future _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('my-throttler', const Duration(milliseconds: 800),
          () async {
        await _whisperController.onLoad();
        _whisperController.isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _whisperController.onRefresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // 在这里根据父级容器的约束条件构建小部件树
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: constraints.maxWidth / 4,
                      child: Obx(
                        () => GridView.count(
                          primary: false,
                          crossAxisCount: 4,
                          padding: const EdgeInsets.all(0),
                          children: [
                            ..._whisperController.noticesList.map((element) {
                              return InkWell(
                                onTap: () {},
                                onLongPress: () {},
                                borderRadius: StyleString.mdRadius,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Badge(
                                      isLabelVisible: element['count'] > 0,
                                      label: Text(element['count'] > 99
                                          ? '99+'
                                          : element['count'].toString()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          element['icon'],
                                          size: 21,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(element['title'])
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map? data = snapshot.data;
                    if (data != null && data['status']) {
                      RxList sessionList = _whisperController.sessionList;
                      return Obx(
                        () => sessionList.isEmpty
                            ? const SizedBox()
                            : ListView.separated(
                                itemCount: sessionList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, int i) {
                                  return SessionItem(
                                    sessionItem: sessionList[i],
                                    changeFucCall: () => sessionList.refresh(),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    indent: 72,
                                    endIndent: 20,
                                    height: 6,
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.1),
                                  );
                                },
                              ),
                      );
                    } else {
                      // 请求错误
                      return Center(
                        child: Text(data?['msg'] ?? '请求异常'),
                      );
                    }
                  } else {
                    return ListView.builder(
                      itemCount: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, int i) {
                        return Skeleton(
                          child: ListTile(
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            title: Container(
                              width: 100,
                              height: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                            ),
                            subtitle: Container(
                              width: 80,
                              height: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
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
  @override
  Widget build(BuildContext context) {
    final String heroTag =
        StringUtils.makeHeroTag(sessionItem.accountInfo?.mid ?? 0);
    final isOfficial = sessionItem.officialAccount != null;
    final content = sessionItem.lastMsg.content;
    final msgStatus = sessionItem.lastMsg.msgStatus;
    final int msgType = sessionItem.lastMsg.msgType;
    return ListTile(
      onTap: () {
        sessionItem.unreadCount = 0;
        changeFucCall.call();
        Get.toNamed(
          '/whisperDetail',
          parameters: {
            'talkerId': sessionItem.talkerId.toString(),
            'name': sessionItem.accountInfo.name,
            'face': sessionItem.accountInfo.face,
            'mid': (sessionItem.accountInfo?.mid ?? 0).toString(),
            'heroTag': heroTag,
          },
        );
      },
      leading: Badge(
        isLabelVisible: sessionItem.unreadCount > 0,
        label: Text(sessionItem.unreadCount.toString()),
        alignment: Alignment.topRight,
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(isOfficial
              ? sessionItem.officialAccount['pic_url']
              : sessionItem.accountInfo.face),
        ),
      ),
      title: Text(isOfficial
          ? sessionItem.officialAccount['name']
          : sessionItem.accountInfo.name),
      subtitle: Text(
        msgStatus == 1
            ? '你撤回了一条消息'
            : msgType == 2
                ? '[图片]'
                : isOfficial
                    ? content['relation'].toString()
                    : content != null && content != ''
                        ? (content['title'] ??
                            content['text'] ??
                            content['reply_content'] ??
                            content['content'].toString() ??
                            '不支持的消息类型')
                        : '不支持的消息类型',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Theme.of(context).colorScheme.outline),
      ),
      trailing: Text(
        NumUtils.dateFormat(sessionItem.lastMsg.timestamp),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
