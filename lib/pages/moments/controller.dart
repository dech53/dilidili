import 'package:dilidili/http/dynamics.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/dynamics/dynamics_type.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/dynamics/up.dart';
import 'package:dilidili/model/live/item.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class MomentsController extends GetxController {
  RxBool userLogin = false.obs;
  Rx<UpItem> upInfo = UpItem().obs;
  RxInt initialValue = 0.obs;
  Rx<DynamicsType> dynamicsType = DynamicsType.values[0].obs;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  String? offset = '';
  RxInt mid = (-1).obs;
  Box userInfoCache = SPStorage.userInfo;
  var userInfo;
  Rx<FollowUpModel> upData = FollowUpModel().obs;
  RxList<DynamicItemModel> dynamicsList = <DynamicItemModel>[].obs;
  RxBool isLoadingDynamic = false.obs;
  //过滤
  List filterTypeList = [
    {
      'label': DynamicsType.all.labels,
      'value': DynamicsType.all,
      'enabled': true
    },
    {
      'label': DynamicsType.video.labels,
      'value': DynamicsType.video,
      'enabled': true
    },
    {
      'label': DynamicsType.pgc.labels,
      'value': DynamicsType.pgc,
      'enabled': true
    },
    {
      'label': DynamicsType.article.labels,
      'value': DynamicsType.article,
      'enabled': true
    },
  ];
  Future queryFollowUp({type = 'init'}) async {
    if (!userLogin.value) {
      return {'status': false, 'msg': '账号未登录', 'code': -101};
    }
    if (type == 'init') {
      upData.value.upList = <UpItem>[];
      upData.value.liveList = <LiveUserItem>[];
    }
    var res = await DynamicsHttp.followUp();
    if (res['status']) {
      upData.value = res['data'];
      if (upData.value.upList!.isEmpty) {
        mid.value = -1;
      }
      upData.value.upList!.insertAll(0, [
        UpItem(face: '', uname: '全部动态', mid: -1),
        UpItem(face: userInfo.face, uname: '我', mid: userInfo.mid),
      ]);
    }
    return res;
  }

  Future queryFollowDynamic({type = 'init'}) async {
    if (!userLogin.value) {
      return {'status': false, 'msg': '账号未登录', 'code': -101};
    }
    if (type == 'init') {
      dynamicsList.clear();
    }
    if (type == 'onLoad' && page == 1) {
      return;
    }
    isLoadingDynamic.value = true;
    var res = await DynamicsHttp.followDynamic(
      page: type == 'init' ? 1 : page,
      type: dynamicsType.value.values,
      offset: offset,
      mid: mid.value,
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

  onRefresh() async {
    page = 1;
    await queryFollowUp();
    await queryFollowDynamic();
  }

  @override
  void onInit() {
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
    super.onInit();
  }

  pushDetail(item, floor, {action = 'all'}) async {
    switch (item!.type) {
      case 'DYNAMIC_TYPE_AV':
        String bvid = item.modules.moduleDynamic.major.archive.bvid;
        String cover = item.modules.moduleDynamic.major.archive.cover;
        try {
          int cid = await SearchHttp.ab2c(bvid: bvid);
          Get.toNamed(
              '/video?bvid=$bvid&cid=$cid&mid=${item.modules.moduleAuthor.mid}',
              arguments: {'pic': cover, 'heroTag': bvid});
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        DynamicLiveModel liveRcmd = item.modules.moduleDynamic.major.liveRcmd;
        ModuleAuthorModel author = item.modules.moduleAuthor;
        LiveItemModel liveItem = LiveItemModel.fromJson({
          'title': liveRcmd.title,
          'uname': author.name,
          'cover': liveRcmd.cover,
          'mid': author.mid,
          'face': author.face,
          'roomid': liveRcmd.roomId,
          'watched_show': liveRcmd.watchedShow,
        });
        Get.toNamed('/liveRoom?roomid=${liveItem.roomId}', arguments: {
          'liveItem': liveItem,
          'heroTag': liveItem.roomId.toString()
        });
        break;
      case 'DYNAMIC_TYPE_ARTICLE':
        String title = item.modules.moduleDynamic.major.article.title;
        Get.toNamed('/read', parameters: {
          'title': title,
          'id': item.modules.moduleDynamic.major.article.id.toString(),
          'articleType': 'read'
        });
        break;
      case 'DYNAMIC_TYPE_FORWARD':
        Get.toNamed('/momentsDetail?type=forward',
            arguments: {'item': item, 'floor': floor});
        break;
      case 'DYNAMIC_TYPE_DRAW':
        Get.toNamed('/momentsDetail?type=draw',
            arguments: {'item': item, 'floor': floor});
        break;
    }
  }

  onSelectType(value) async {
    dynamicsType.value = filterTypeList[value]['value'];
    dynamicsList.value = <DynamicItemModel>[];
    page = 1;
    initialValue.value = value;
    await queryFollowDynamic();
    scrollController.jumpTo(0);
  }
}
