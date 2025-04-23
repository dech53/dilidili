import 'package:dilidili/model/search_type.dart';
import 'package:get/get.dart';

class SearchResultController extends GetxController {
  RxList searchTabs = [].obs;
  String? keyword;
  int tabIndex = 0;
  @override
  void onInit() {
    super.onInit();
    if (Get.parameters.keys.isNotEmpty) {
      keyword = Get.parameters['keyword'];
    }
    searchTabs.value = SearchType.values
        .map((type) => {'label': type.label, 'id': type.type})
        .toList();
  }
}
