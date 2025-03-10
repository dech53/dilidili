import 'package:dilidili/utils/log_utils.dart';
import 'package:dio/dio.dart';

class PrintLogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //打印请求信息，方便调试
    Logutils.println("\nonRequest---------->");
    options.headers.forEach((key, value) {
      Logutils.println("headers:key=$key value=${value.tostring()}");
    });
    Logutils.println("path:${options.uri}");
    Logutils.println("method:${options.method}");
    Logutils.println("data:${options.data}");
    Logutils.println("queryParameters:${options.queryParameters.toString()}");
    Logutils.println("<----------onRequest\n");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logutils.println("\nonError---------->");
    Logutils.println("err:${err.toString()}");
    Logutils.println("<----------onError\n");
    super.onError(err, handler);
  }
}
