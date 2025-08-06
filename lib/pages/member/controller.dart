import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/member.dart';
import 'package:dilidili/http/user.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/member/folder_info.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/model/member_tab_type.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MemberController extends GetxController with GetTickerProviderStateMixin {
  late int mid;
  RxString face = ''.obs;
  Rx<MemberInfo> memberInfo = MemberInfo().obs;
  late RxList tabs = [].obs;
  late List tabsCtrList;
  String? heroTag;
  late List<Widget> tabsPageList;

  late Map userStat;
  late int ownerMid;
  SharedPreferencesInstance prefs = SPStorage.prefs;
  RxInt attribute = (-1).obs;
  RxString attributeText = '关注'.obs;
  RxBool isOwner = false.obs;
  @override
  void onInit() async {
    super.onInit();
    face.value = Get.arguments['face'] ?? '';
    tabs.value = memberTabs;
    heroTag = Get.arguments['heroTag'] ?? '';
    tabsCtrList = memberTabs.map((e) => e['ctr']).toList();
    tabsPageList = memberTabs.map<Widget>((e) => e['page']).toList();
    mid = int.parse(Get.arguments['mid']!);

    //获取当前登录用户的mid
    ownerMid = SPStorage.userInfo.get('userInfoCache').mid;
    isOwner.value = mid == ownerMid;
    relationSearch();
  }

  // 获取用户信息
  Future<Map<String, dynamic>> getInfo() async {
    await getMemberStat();
    await getMemberView();
    var res = await MemberHttp.memberInfo(mid: mid);
    if (res['status']) {
      memberInfo.value = res['data'];
    }
    return res;
  }

  // 获取用户状态
  Future<Map<String, dynamic>> getMemberStat() async {
    var res = await MemberHttp.memberStat(mid: mid);
    if (res['status']) {
      userStat = res['data'];
    }
    return res;
  }

  // 获取用户播放数 获赞数
  Future<Map<String, dynamic>> getMemberView() async {
    var res = await MemberHttp.memberView(mid: mid);
    if (res['status']) {
      userStat.addAll(res['data']);
    }
    return res;
  }

  // 关系查询
  Future relationSearch() async {
    if (mid == ownerMid) return;
    var res = await UserHttp.hasFollow(mid);
    if (res['status']) {
      attribute.value = res['data']['attribute'];
      switch (attribute.value) {
        case 1:
          attributeText.value = '悄悄关注';
          break;
        case 2:
          attributeText.value = '已关注';
          break;
        case 6:
          attributeText.value = '已互关';
          break;
        case 128:
          attributeText.value = '已拉黑';
          break;
        default:
          attributeText.value = '关注';
      }
      if (res['data']['special'] == 1) {
        attributeText.value += 'SP';
      }
    }
  }

  //关注相关操作
  Future actionRelationMod() async {
    await VideoHttp.relationMod(
      mid: mid,
      act: memberInfo.value.isFollowed! ? 2 : 1,
      reSrc: 11,
    );
    SmartDialog.showToast('操作成功');

    memberInfo.value.isFollowed = !memberInfo.value.isFollowed!;
    relationSearch();
    memberInfo.update((val) {});
  }
}
