import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class SetCookie {
  static set() async {
    var cookies = await WebviewCookieManager().getCookies(ApiString.mainUrl);
    await DioInstance.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(ApiString.mainUrl), cookies);
    var cookieString =
        cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    DioInstance.dio.options.headers['cookie'] = cookieString;

    cookies = await WebviewCookieManager().getCookies(ApiString.baseUrl);
    await DioInstance.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(ApiString.baseUrl), cookies);

    cookies = await WebviewCookieManager().getCookies(ApiString.baseMsgUrl);
    await DioInstance.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(ApiString.baseMsgUrl), cookies);
  }
}
