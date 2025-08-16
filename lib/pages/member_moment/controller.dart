import 'package:dilidili/http/member.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:get/get.dart';

class MemberMomentController extends GetxController {
  RxList<MomentItemModel> momentsList = <MomentItemModel>[].obs;
  String offset = '';
  late int mid;
  int count = 0;
  bool hasMore = true;
  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.arguments['mid']!);
  }

  Future getMemberDynamic(type) async {
    if (type == 'onRefresh') {
      offset = '';
      momentsList.clear();
    }
    if (offset == '-1') {
      return;
    }
    var res = await MemberHttp.memberMoment(
      offset: offset,
      mid: mid,
    );
    if (res['status']) {
      momentsList.addAll(res['data'].items);
      offset = res['data'].offset != '' ? res['data'].offset : '-1';
      hasMore = res['data'].hasMore;
    }
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    getMemberDynamic('onLoad');
  }
}
