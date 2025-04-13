import 'package:dilidili/http/http_methods.dart';
import 'package:dilidili/http/print_log_interceptor.dart';
import 'package:dilidili/http/response_interceptor.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/utils/file_utils.dart';
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

  static late CookieManager cookieManager;

  static final Dio _dio = Dio();
  static final _defaultTimeout = const Duration(seconds: 30);
  static initDio({
    String? httpMethod = HttpMethods.get,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) async {
    final String cookiePath = await FileUtils.getCookiePath();
    _dio.options = BaseOptions(
      method: httpMethod,
      connectTimeout: connectTimeout ?? _defaultTimeout,
      receiveTimeout: receiveTimeout ?? _defaultTimeout,
      sendTimeout: sendTimeout ?? _defaultTimeout,
      responseType: responseType,
      contentType: contentType,
    );
    final PersistCookieJar cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );
    cookieManager = CookieManager(cookieJar);
    _dio.interceptors.add(cookieManager);
    final List<Cookie> cookie = await cookieManager.cookieJar
        .loadForRequest(Uri.parse(ApiString.baseUrl));
    final String cookieString = cookie
        .map((Cookie cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');
    _dio.options.headers['cookie'] = cookieString;
    _dio.options.headers['user-agent'] = HeaderUtil.randomHeader();
    // _dio.interceptors.add(ResponseInterceptor());
    // _dio.interceptors.add(PrintLogInterceptor());
  }

  // 从cookie中获取 csrf token
   Future<String> getCsrf() async {
    List<Cookie> cookies = await cookieManager.cookieJar
        .loadForRequest(Uri.parse(ApiString.baseUrl));
    String token = '';
    if (cookies.where((e) => e.name == 'bili_jct').isNotEmpty) {
      token = cookies.firstWhere((e) => e.name == 'bili_jct').value;
    }
    return token;
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
