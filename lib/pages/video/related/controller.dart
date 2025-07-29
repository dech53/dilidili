import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:get/get.dart';

class ReleatedVideoController extends GetxController {

  String bvid = Get.arguments['bvid'] ?? "";

  RxList relatedVideoList = <RelatedVideoItem>[].obs;
  
  Future<dynamic> queryRelatedVideo() async {
    return VideoHttp.relatedVideoList(bvid: bvid).then((value) {
      if (value['status']) {
        relatedVideoList.value = value['data'];
      }
      return value;
    });
  }
}
