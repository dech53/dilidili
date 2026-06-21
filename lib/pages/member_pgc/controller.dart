import 'package:dilidili/http/member.dart';
import 'package:dilidili/model/member/contribute_type.dart';
import 'package:dilidili/model/space/space/data.dart';
import 'package:dilidili/model/space/space/season.dart';
import 'package:dilidili/model/space/space_archive/data.dart';
import 'package:dilidili/model/space/space_archive/item.dart';
import 'package:dilidili/pages/member/controller.dart';
import 'package:get/get.dart';

class MemberBangumiCtr extends GetxController {
  MemberBangumiCtr({
    required this.mid,
    required this.heroTag,
  });

  final int mid;
  final String? heroTag;

  final RxList<SpaceArchiveItem> itemList = <SpaceArchiveItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;

  int page = 1;
  int? count;
  bool isEnd = false;

  late final MemberController _ctr = _findMemberController();

  @override
  void onInit() {
    super.onInit();
    final SpaceData? response = _ctr.spaceData.value;
    final SpaceSeason? season = response?.season;
    if (season != null) {
      page = 2;
      final List<SpaceArchiveItem> items = season.item ?? <SpaceArchiveItem>[];
      itemList.assignAll(items);
      count = season.count ?? items.length;
      checkIsEnd(itemList.length);
    } else {
      queryData();
    }
  }

  MemberController _findMemberController() {
    if (heroTag != null && Get.isRegistered<MemberController>(tag: heroTag)) {
      return Get.find<MemberController>(tag: heroTag);
    }
    final String midTag = mid.toString();
    if (Get.isRegistered<MemberController>(tag: midTag)) {
      return Get.find<MemberController>(tag: midTag);
    }
    return Get.find<MemberController>(tag: heroTag);
  }

  Future<void> onRefresh() async {
    page = 1;
    isEnd = false;
    errorMsg.value = '';
    await queryData(isRefresh: true);
  }

  Future<void> onReload() async {
    await onRefresh();
  }

  Future<void> onLoadMore() async {
    if (isEnd) return;
    await queryData();
  }

  void checkIsEnd(int length) {
    if (count != null && length >= count!) {
      isEnd = true;
    }
  }

  Future<void> queryData({bool isRefresh = false}) async {
    if (isLoading.value) return;
    if (!isRefresh && isEnd) return;

    isLoading.value = true;
    try {
      final int requestPage = isRefresh ? 1 : page;
      final res = await MemberHttp.spaceArchive(
        type: ContributeType.bangumi,
        mid: mid,
        pn: requestPage,
      );

      if (res['status']) {
        final SpaceArchiveData response = res['data'];
        final List<SpaceArchiveItem> items =
            response.item ?? <SpaceArchiveItem>[];
        count = response.count ?? count;
        if (isRefresh) {
          itemList.assignAll(items);
        } else {
          itemList.addAll(items);
        }
        page = requestPage + 1;
        if (response.hasNext == false || items.isEmpty) {
          isEnd = true;
        }
        checkIsEnd(itemList.length);
        errorMsg.value = '';
      } else {
        errorMsg.value = res['msg']?.toString() ?? '请求异常';
      }
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
