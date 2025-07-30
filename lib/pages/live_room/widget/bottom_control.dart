import 'package:dilidili/component/common_btn.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/live_room/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomControl extends StatefulWidget implements PreferredSizeWidget {
  const BottomControl({
    this.controller,
    this.liveRoomController,
    this.onRefresh,
    Key? key,
  }) : super(key: key);
  final DPlayerController? controller;
  final LiveRoomController? liveRoomController;
  final Function? onRefresh;

  @override
  State<BottomControl> createState() => _BottomControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _BottomControlState extends State<BottomControl> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          ComBtn(
            icon: const Icon(
              Icons.refresh_outlined,
              size: 18,
              color: Colors.white,
            ),
            fuc: widget.onRefresh,
          ),
          const Spacer(),
          SizedBox(
            width: 30,
            child: PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              onSelected: (value) {
                ///切换画质
                widget.liveRoomController!.changeQn(value);
              },
              child: Obx(
                () => Text(
                  widget.liveRoomController!.currentQnDesc.value,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              itemBuilder: (BuildContext context) {
                return widget.liveRoomController!.acceptQnList.map((e) {
                  return PopupMenuItem<int>(
                    value: e['code'],
                    child: Text(e['desc']),
                  );
                }).toList();
              },
            ),
          ),
          ComBtn(
            icon: const Icon(
              Icons.fullscreen,
              size: 20,
              color: Colors.white,
            ),
            fuc: () => widget.controller!.triggerFullScreen(
                status: !(widget.controller!.isFullScreen.value)),
          ),
        ],
      ),
    );
  }
}
