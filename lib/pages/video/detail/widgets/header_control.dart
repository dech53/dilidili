import 'package:dilidili/component/common_btn.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/video/detail/controller.dart';
import 'package:dilidili/pages/video/introduction/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  const HeaderControl({
    this.controller,
    this.videoDetailCtr,
    this.bvid,
    this.videoType,
    this.showSubtitleBtn,
    super.key,
  });
  final DPlayerController? controller;
  final VideoDetailController? videoDetailCtr;
  final String? bvid;
  final SearchType? videoType;
  final bool? showSubtitleBtn;

  @override
  State<HeaderControl> createState() => _HeaderControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderControlState extends State<HeaderControl> {
  late PlayUrlModel videoInfo;
  late String heroTag;
  late VideoIntroController videoIntroController;
  RxBool isFullScreen = false.obs;
  @override
  void initState() {
    super.initState();
    videoInfo = widget.videoDetailCtr!.data;
    fullScreenStatusListener();
    heroTag = Get.arguments['heroTag'];
    videoIntroController =
        Get.put(VideoIntroController(bvid: widget.bvid!), tag: heroTag);
  }

  void fullScreenStatusListener() {
    widget.videoDetailCtr!.dPlayerController.isFullScreen.listen((bool val) {
      isFullScreen.value = val;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ = widget.controller!;
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
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
              FontAwesomeIcons.arrowLeft,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => <Set<void>>{
              if (widget.controller!.isFullScreen.value)
                <void>{widget.controller!.triggerFullScreen(status: false)}
              else
                <void>{
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape)
                    {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ])
                    },
                  Get.back()
                }
            },
          ),
        ],
      ),
    );
  }
}
