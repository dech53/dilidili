import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  String url = '';
  RxBool loadShow = true.obs;
  RxInt loadProgress = 0.obs;
  RxString type = ''.obs;
  String pageTitle = '';
  final WebViewController controller = WebViewController();
  @override
  void onInit() {
    super.onInit();
    url = Get.parameters['url']!;
    type.value = Get.parameters['type']!;
    pageTitle = Get.parameters['pageTitle']!;
    webviewInit();
  }

  webviewInit() {
    controller
      ..setUserAgent(DioInstance.instance().headerUa())
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            loadProgress.value = progress;
          },
          onPageStarted: (String url) {
            final List pathSegments = Uri.parse(url).pathSegments;
            if (pathSegments.isNotEmpty &&
                url != 'https://passport.bilibili.com/h5-app/passport/login') {
              final String str = pathSegments[0];
              final Map matchRes = IdUtils.matchAvorBv(input: str);
              final List matchKeys = matchRes.keys.toList();
              if (matchKeys.isNotEmpty) {
                if (matchKeys.first == 'BV') {
                  Get.offAndToNamed(
                    '/searchResult',
                    parameters: {'keyword': matchRes['BV']},
                  );
                }
              }
            }
          },
          onUrlChange: (UrlChange urlChange) async {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('bilibili://')) {
              if (request.url.startsWith('bilibili://video/')) {
                String str = Uri.parse(request.url).pathSegments[0];
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url.startsWith('http') ? url : 'https://$url'));
  }
}
