import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/view.dart';
import 'package:dilidili/pages/live_room/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/network_img_layer.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with TickerProviderStateMixin {
  final LiveRoomController _liveRoomController = Get.put(LiveRoomController());
  late Future? _futureBuilder;
  late Future? _futureBuilderFuture;
  late DPlayerController dPlayerController;
  final int roomId = int.parse(Get.parameters['roomid']!);

  @override
  void initState() {
    super.initState();
    videoSourceInit();
    _futureBuilderFuture = _liveRoomController.queryLiveInfo();
  }

  Future<void> videoSourceInit() async {
    _futureBuilder = _liveRoomController.queryLiveInfoH5();
    dPlayerController = _liveRoomController.dPlayerController;
  }

  @override
  void dispose() {
    dPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget videoPlayerPanel = FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['status']) {
          dPlayerController = _liveRoomController.dPlayerController;
          return DPlayer(controller: dPlayerController);
        } else {
          return const SizedBox();
        }
      },
    );

    return Scaffold(
      primary: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(
            () => Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _liveRoomController
                              .roomInfoH5.value.roomInfo?.appBackground !=
                          '' &&
                      _liveRoomController
                              .roomInfoH5.value.roomInfo?.appBackground !=
                          null
                  ? Opacity(
                      opacity: 0.6,
                      child: NetworkImgLayer(
                        width: Get.width,
                        height: Get.height,
                        type: 'bg',
                        src: _liveRoomController
                                .roomInfoH5.value.roomInfo?.appBackground ??
                            '',
                      ),
                    )
                  : Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'assets/images/live/default_bg.webp',
                        fit: BoxFit.cover,
                        // width: Get.width,
                        // height: Get.height,
                      ),
                    ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => SizedBox(
                  height: MediaQuery.of(context).padding.top +
                      (_liveRoomController.isPortrait.value ||
                              MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                          ? 0
                          : kToolbarHeight),
                ),
              ),
              PopScope(
                child: Obx(
                  () => Container(
                    width: Get.size.width,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? Get.size.height
                        : !_liveRoomController.isPortrait.value
                            ? Get.size.width * 9 / 16
                            : Get.size.height -
                                MediaQuery.of(context).padding.top,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: videoPlayerPanel,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              centerTitle: false,
              titleSpacing: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              toolbarHeight:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 56
                      : 0,
              title: FutureBuilder(
                future: _futureBuilder,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }
                  Map data = snapshot.data as Map;
                  if (data['status']) {
                    return Obx(
                      () => Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                '/member?mid=${_liveRoomController.roomInfoH5.value.roomInfo?.uid}',
                                arguments: {
                                  'face': _liveRoomController.roomInfoH5.value
                                      .anchorInfo!.baseInfo!.face
                                },
                              );
                            },
                            child: NetworkImgLayer(
                              width: 34,
                              height: 34,
                              type: 'avatar',
                              src: _liveRoomController
                                  .roomInfoH5.value.anchorInfo!.baseInfo!.face,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _liveRoomController.roomInfoH5.value.anchorInfo!
                                    .baseInfo!.uname!,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 1),
                              if (_liveRoomController
                                      .roomInfoH5.value.watchedShow !=
                                  null)
                                Text(
                                  _liveRoomController.roomInfoH5.value
                                          .watchedShow!['text_large'] ??
                                      '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
