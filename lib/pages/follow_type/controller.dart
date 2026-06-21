import 'package:dilidili/http/member.dart';
import 'package:dilidili/model/follow/result.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:get/get.dart';

abstract class FollowTypeController extends GetxController {
  late final int mid;
  late final RxnString name;

  final RxInt total = 0.obs;
  final RxList<FollowItemModel> itemList = <FollowItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;

  int page = 1;
  bool isEnd = false;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    final dynamic userInfo = SPStorage.userInfo.get('userInfoCache');
    final int? ownerMid = int.tryParse(userInfo?.mid?.toString() ?? '');
    final Map? args = Get.arguments;
    mid = _safeToInt(args?['mid'] ?? Get.parameters['mid'] ?? ownerMid) ?? 0;
    final String? name = args?['name']?.toString() ?? Get.parameters['name'];
    this.name = RxnString(name);
    if (name == null || name.isEmpty) {
      queryUserName();
    }
    queryData(isRefresh: true);
  }

  Future<void> queryUserName() async {
    if (mid <= 0) return;
    final res = await MemberHttp.memberInfo(mid: mid);
    if (res['status']) {
      final MemberInfo memberInfo = res['data'];
      name.value = memberInfo.name;
    }
  }

  Future<Map<String, dynamic>> customGetData();

  Future<void> onRefresh() async {
    await queryData(isRefresh: true);
  }

  Future<void> onReload() async {
    await queryData(isRefresh: true);
  }

  Future<void> onLoadMore() async {
    if (isEnd) return;
    await queryData();
  }

  Future<void> queryData({bool isRefresh = false}) async {
    if (isLoading.value) return;
    if (!isRefresh && isEnd) return;

    if (isRefresh) {
      page = 1;
      isEnd = false;
      errorMsg.value = '';
    }

    isLoading.value = true;
    try {
      final res = await customGetData();
      if (res['status']) {
        final FollowDataModel response = res['data'];
        final List<FollowItemModel> items =
            response.list ?? <FollowItemModel>[];
        total.value = response.total ?? 0;
        if (isRefresh) {
          itemList.assignAll(items);
        } else {
          itemList.addAll(items);
        }
        page += 1;
        checkIsEnd(items.length);
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

  void checkIsEnd(int lastLength) {
    if (lastLength == 0) {
      isEnd = true;
      return;
    }
    if (total.value > 0 && itemList.length >= total.value) {
      isEnd = true;
    }
  }

  int? _safeToInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
