import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/widgets/toolbar_icon_button.dart';
import 'package:dilidili/pages/whisper_detail/controller.dart';
import 'package:dilidili/pages/whisper_detail/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhisperDetailPage extends StatefulWidget {
  const WhisperDetailPage({super.key});

  @override
  State<WhisperDetailPage> createState() => _WhisperDetailPageState();
}

class _WhisperDetailPageState extends State<WhisperDetailPage>
    with WidgetsBindingObserver {
  final WhisperDetailController _whisperDetailController =
      Get.put(WhisperDetailController());
  late Future _futureBuilderFuture;
  late TextEditingController _replyContentController;
  final FocusNode replyContentFocusNode = FocusNode();
  late double emoteHeight = 230.0;
  double keyboardHeight = 0.0; // 键盘高度
  RxString toolbarType = ''.obs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _futureBuilderFuture = _whisperDetailController.querySessionMsg();
    _replyContentController = _whisperDetailController.replyContentController;
    _focuslistener();
  }

  _focuslistener() {
    replyContentFocusNode.addListener(() {
      if (replyContentFocusNode.hasFocus) {
        toolbarType.value = 'input';
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    replyContentFocusNode.removeListener(() {});
    replyContentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Get.toNamed(
                  '/member?mid=${_whisperDetailController.mid}',
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 34,
                      height: 34,
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          _whisperDetailController.face,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _whisperDetailController.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                toolbarType.value = '';
              },
              child: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    final Map data = snapshot.data as Map;
                    if (data['status']) {
                      List messageList = _whisperDetailController.messageList;
                      return Obx(
                        () => messageList.isEmpty
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.topCenter,
                                child: ListView.separated(
                                  itemCount: messageList.length,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemBuilder: (_, int i) {
                                    return ChatCard(
                                      item: messageList[i],
                                      e_infos: _whisperDetailController.eInfos,
                                    );
                                  },
                                  separatorBuilder: (_, int i) {
                                    return i == 0
                                        ? const SizedBox(height: 20)
                                        : const SizedBox.shrink();
                                  },
                                ),
                              ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.fromLTRB(
                8,
                12,
                12,
                toolbarType.value == ''
                    ? MediaQuery.of(context).padding.bottom + 6
                    : 6,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.grey.withOpacity(0.15),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToolbarIconButton(
                    onPressed: () {
                      if (toolbarType.value == '') {
                        toolbarType.value = 'emote';
                      } else if (toolbarType.value == 'input') {
                        FocusScope.of(context).unfocus();
                        toolbarType.value = 'emote';
                      } else if (toolbarType.value == 'emote') {
                        FocusScope.of(context).requestFocus();
                      }
                    },
                    icon: const Icon(Icons.emoji_emotions_outlined, size: 22),
                    toolbarType: toolbarType.value,
                    selected: false,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: TextField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: _replyContentController,
                        autofocus: false,
                        focusNode: replyContentFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none, // 移除默认边框
                          hintText: '文明发言 ～', // 提示文本
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0), // 内边距
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _whisperDetailController.sendMsg,
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
