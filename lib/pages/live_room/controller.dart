import 'package:dilidili/http/live.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/live/quality.dart';
import 'package:dilidili/model/live/room_info.dart';
import 'package:dilidili/model/live/room_info_h5.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/data_source.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LiveRoomController extends GetxController {
  late int roomId;
  DPlayerController dPlayerController = DPlayerController(videoType: 'live');
  dynamic liveItem;
  RxString currentQnDesc = ''.obs;
  int? tempCurrentQn;
  RxBool isPortrait = false.obs;
  int currentQn = LiveQuality.values.last.code;
  late String buvid;
  late List<Map<String, dynamic>> acceptQnList;
  Rx<RoomInfoH5Model> roomInfoH5 = RoomInfoH5Model().obs;
  Future queryLiveInfoH5() async {
    var res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res['status']) {
      roomInfoH5.value = res['data'];
    }
    return res;
  }

  Future queryLiveInfo() async {
    var res = await LiveHttp.liveRoomInfo(roomId: roomId, qn: currentQn);
    if (res['status']) {
      isPortrait.value = res['data'].isPortrait;
      List<CodecItem> codec =
          res['data'].playurlInfo.playurl.stream.first.format.first.codec;
      CodecItem item = codec.first;
      currentQn = item.currentQn!;
      if (tempCurrentQn != null && tempCurrentQn == currentQn) {
        SmartDialog.showToast('画质切换失败，请检查登录状态');
      }
      List acceptQn = item.acceptQn!;
      acceptQnList = acceptQn.map((e) {
        return {
          'code': e,
          'desc': LiveQuality.values
              .firstWhere((element) => element.code == e)
              .description,
        };
      }).toList();
      currentQnDesc.value = LiveQuality.values
          .firstWhere((element) => element.code == currentQn)
          .description;
      String videoUrl = (item.urlInfo?.first.host)! +
          item.baseUrl! +
          item.urlInfo!.first.extra!;
      await playerInit(videoUrl);
      return res;
    }
  }

  playerInit(source) async {
    await dPlayerController.setDataSource(
      DataSource(
        videoSource: source,
        audioSource: null,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': ApiString.mainUrl
        },
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    roomId = int.parse(Get.parameters['roomid']!);
    if (Get.arguments != null) {
      liveItem = Get.arguments['liveItem'];
    }
  }
}
