import 'package:dilidili/http/danmaku.dart';
import 'package:dilidili/model/danmaku/dm.pb.dart';
import 'package:get/get.dart';

class DanmukuController extends GetxController {
  DanmukuController(this.cid, this.type);
  Map<int, List<DanmakuElem>> dmSegMap = {};
  final int cid;
  final String type;
  List<bool> requestedSeg = [];
  static int segmentLength = 60 * 6 * 1000;
  void initiate(int videoDuration, int progress) {
    if (requestedSeg.isEmpty) {
      int segCount = (videoDuration / segmentLength).ceil();
      requestedSeg = List<bool>.generate(segCount, (index) => false);
    }
    try {
      queryDanmaku(calcSegment(progress));
    } catch (e) {
      print(e);
    }
  }

  void queryDanmaku(int segmentIndex) async {
    assert(requestedSeg[segmentIndex] == false);
    if (requestedSeg.length > segmentIndex) {
      requestedSeg[segmentIndex] = true;
      final DmSegMobileReply result = await DanmakaHttp.queryDanmaku(
          cid: cid, segmentIndex: segmentIndex + 1);
      if (result.elems.isNotEmpty) {
        for (var element in result.elems) {
          int pos = element.progress ~/ 100;
          if (dmSegMap[pos] == null) {
            dmSegMap[pos] = [];
          }
          dmSegMap[pos]!.add(element);
        }
      }
    }
  }

  int calcSegment(int progress) {
    return progress ~/ segmentLength;
  }

  List<DanmakuElem>? getCurrentDanmaku(int progress) {
    int segmentIndex = calcSegment(progress);
    if (!requestedSeg[segmentIndex]) {
      queryDanmaku(segmentIndex);
    }
    return dmSegMap[progress ~/ 100];
  }
}
