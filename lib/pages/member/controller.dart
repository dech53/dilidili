import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/member.dart';
import 'package:dilidili/http/user.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/model/member_tab_type.dart';
import 'package:dilidili/model/space/space/data.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MemberController extends GetxController with GetTickerProviderStateMixin {
  late int mid;
  RxString face = ''.obs;
  Rx<MemberInfo> memberInfo = MemberInfo().obs;
  Rxn<SpaceData> spaceData = Rxn<SpaceData>();
  RxBool isSpaceLoading = true.obs;
  PageController? _headerPageController;
  final RxList<MemberTabConfig> tabs = <MemberTabConfig>[].obs;
  List<Tab> tabWidgets = [];
  TabController? tabController;
  String? heroTag;

  Map userStat = {};
  late int ownerMid;
  SharedPreferencesInstance prefs = SPStorage.prefs;
  RxInt attribute = (-1).obs;
  RxString attributeText = '关注'.obs;
  RxBool isOwner = false.obs;
  @override
  void onInit() async {
    super.onInit();
    face.value = Get.arguments['face'] ?? '';
    heroTag = Get.arguments['heroTag'] ?? '';
    mid = int.parse(Get.arguments['mid']!);

    //获取当前登录用户的mid
    ownerMid = SPStorage.userInfo.get('userInfoCache').mid;
    isOwner.value = mid == ownerMid;
    relationSearch();
  }

  PageController get headerPageController {
    return _headerPageController ??= PageController();
  }

  @override
  void onClose() {
    _headerPageController?.dispose();
    tabController?.dispose();
    super.onClose();
  }

  void updateTabs(List<MemberTabConfig> nextTabs, {String? defaultTab}) {
    final List<MemberTabConfig> effectiveTabs = nextTabs;
    final TabController? oldController = tabController;
    if (effectiveTabs.isEmpty) {
      tabController = null;
      tabWidgets = [];
      tabs.value = [];
      oldController?.dispose();
      return;
    }

    final String normalizedDefaultTab = normalizeMemberDefaultTab(defaultTab);
    final int defaultIndex = effectiveTabs.indexWhere(
      (item) => item['param'] == normalizedDefaultTab,
    );
    final int currentIndex = tabController?.index ?? 0;
    final int initialIndex = defaultIndex >= 0
        ? defaultIndex
        : currentIndex.clamp(0, effectiveTabs.length - 1).toInt();

    tabController = TabController(
      vsync: this,
      length: effectiveTabs.length,
      initialIndex: initialIndex,
    );
    tabWidgets = effectiveTabs
        .map((item) => Tab(text: item['label'] as String? ?? ''))
        .toList();
    tabs.value = effectiveTabs;
    oldController?.dispose();
  }

  void onTapTab(int value) {}

  // 获取用户信息
  Future<Map<String, dynamic>> getInfo() async {
    final spaceFuture = getSpaceInfo();
    final infoFuture = MemberHttp.memberInfo(mid: mid);
    final List<dynamic> results = await Future.wait([spaceFuture, infoFuture]);
    final Map<String, dynamic> spaceRes = results[0];
    final Map<String, dynamic> infoRes = results[1];
    if (infoRes['status']) {
      memberInfo.value = infoRes['data'];
    }
    _loadLegacyStats();
    return spaceRes['status'] ? spaceRes : infoRes;
  }

  Future<void> _loadLegacyStats() async {
    await getMemberStat();
    await getMemberView();
  }

  Future<Map<String, dynamic>> getSpaceInfo() async {
    isSpaceLoading.value = true;
    try {
      var res = await MemberHttp.space(mid: mid);
      if (res['status']) {
        final SpaceData data = res['data'];
        spaceData.value = data;
        updateRelationFromSpace(data);
        updateTabs(
          memberTabsFromSpace(data.tab2, hasItem: data.hasItem),
          defaultTab: data.defaultTab,
        );
      } else {
        updateTabs(fallbackMemberTabs(), defaultTab: 'contribute');
      }
      return res;
    } catch (e) {
      updateTabs(fallbackMemberTabs(), defaultTab: 'contribute');
      return {
        'status': false,
        'data': [],
        'msg': e.toString(),
      };
    } finally {
      isSpaceLoading.value = false;
    }
  }

  void updateRelationFromSpace(SpaceData data) {
    if (mid == ownerMid) return;
    final int nextAttribute;
    if (data.relation == -1) {
      nextAttribute = 128;
    } else if (data.card?.relation?.isFollow == 1) {
      nextAttribute =
          data.relSpecial == 1 ? -10 : data.card?.relation?.status ?? 2;
    } else {
      nextAttribute = 0;
    }
    attribute.value = nextAttribute;
    attributeText.value = _relationText(nextAttribute);
  }

  String _relationText(int value) {
    return switch (value) {
      1 => '悄悄关注',
      2 => '已关注',
      4 || 6 => '已互关',
      128 => '移除黑名单',
      -10 => '特别关注',
      _ => '关注',
    };
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
      attributeText.value = _relationText(attribute.value);
      if (res['data']['special'] == 1) {
        attributeText.value += 'SP';
      }
    }
  }

  //关注相关操作
  Future actionRelationMod() async {
    final bool isBlocked = attribute.value == 128;
    final bool isFollow =
        attribute.value != 0 && attribute.value != 128 && attribute.value != -1;
    await VideoHttp.relationMod(
      mid: mid,
      act: isBlocked
          ? 6
          : isFollow
              ? 2
              : 1,
      reSrc: 11,
    );
    SmartDialog.showToast('操作成功');

    attribute.value = isBlocked || isFollow ? 0 : 2;
    attributeText.value = _relationText(attribute.value);
    memberInfo.value.isFollowed = attribute.value != 0;
    memberInfo.update((val) {});
  }
}
