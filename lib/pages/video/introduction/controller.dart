import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:get/get.dart';

class VideoIntroController extends GetxController {
  VideoIntroController({required this.bvid});
  String bvid;
  int mid = int.parse(Get.parameters['mid']!);
  Rx<UserCardInfo> userInfo = UserCardInfo().obs;
  Rx<VideoDetailData> videoDetail = VideoDetailData().obs;
  Future queryVideoIntro() async {
    var result = await VideoHttp.videoIntro(bvid: bvid);
    if (result['status']) {
      videoDetail.value = result['data'];
    }
    await queryUserInfo();
    return result;
  }

  Future queryUserInfo() async {
    var result = await VideoHttp.userInfo(mid: mid);
    if (result['status']) {
      userInfo.value = result['data'];
    }
  }
}
