import 'package:dilidili/http/dynamics.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/dynamics/up.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class UpDynamicsController extends GetxController {
  UpDynamicsController(this.upInfo);
  UpItem upInfo;
  RxList<MomentItemModel> dynamicsList = <MomentItemModel>[].obs;
  RxBool isLoadingDynamic = false.obs;
  String? offset = '';
  int page = 1;
  Future queryFollowDynamic({type = 'init'}) async {
    if (type == 'init') {
      dynamicsList.clear();
    }
    if (type == 'onLoad' && page == 1) {
      return;
    }
    isLoadingDynamic.value = true;
    var res = await MomentsHttp.followDynamic(
      page: type == 'init' ? 1 : page,
      type: 'all',
      offset: offset,
      mid: upInfo.mid,
    );
    isLoadingDynamic.value = false;
    if (res['status']) {
      if (type == 'onLoad' && res['data'].items.isEmpty) {
        SmartDialog.showToast('没有更多了');
        return;
      }
      if (type == 'init') {
        dynamicsList.value = res['data'].items;
      } else {
        dynamicsList.addAll(res['data'].items);
      }
      offset = res['data'].offset;
      page++;
    }
    return res;
  }
}
