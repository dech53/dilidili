import 'package:dilidili/http/http_methods.dart';
import 'package:dilidili/http/print_log_interceptor.dart';
import 'package:dilidili/http/response_interceptor.dart';
import 'package:dilidili/utils/header_utils.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class DioInstance {
  static DioInstance? _instance;
  DioInstance._();
  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final _defaultTimeout = const Duration(seconds: 30);
  void initDio({
    String? httpMethod = HttpMethods.get,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) {
    _dio.options = BaseOptions(
      method: httpMethod,
      connectTimeout: connectTimeout ?? _defaultTimeout,
      receiveTimeout: receiveTimeout ?? _defaultTimeout,
      sendTimeout: sendTimeout ?? _defaultTimeout,
      responseType: responseType,
      contentType: contentType,
    );
    _dio.interceptors.add(ResponseInterceptor());
    _dio.interceptors.add(PrintLogInterceptor());
    _dio.interceptors.add(
      CookieManager(
        PersistCookieJar(
          persistSession: true,
          storage:
              FileStorage("${getApplicationDocumentsDirectory()}/.cookies/"),
        ),
      ),
    );
  }

  //get请求
  Future<Response> get({
    required String path,
    Object? data,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get(
      path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
            headers: {
              'user-agent': HeaderUtil.randomHeader(),
            },
            method: HttpMethods.get,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
  }

  //获取json数据
  Future<String> getString({
    required String path,
    Object? data,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Response res = await _dio.get(
      path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
            method: HttpMethods.get,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
    return res.data.toString();
  }

  //post请求
  Future<Response> post({
    required String path,
    Object? data,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post(
      path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
            method: HttpMethods.post,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
  }
}
