import 'dart:io';
import 'dart:math';

import 'package:dilidili/http/http_methods.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/utils/file_utils.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:uuid/uuid.dart';

class DioInstance {
  static DioInstance? _instance;
  static String? buvid;
  static final Random _random = Random();
  DioInstance._();
  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  static late CookieManager cookieManager;

  static final Dio dio = Dio();
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
    dio.options = BaseOptions(
      method: httpMethod,
      connectTimeout: connectTimeout ?? _defaultTimeout,
      receiveTimeout: receiveTimeout ?? _defaultTimeout,
      sendTimeout: sendTimeout ?? _defaultTimeout,
      responseType: responseType,
      contentType: contentType,
      maxRedirects: 3,
    );
    final PersistCookieJar cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );
    cookieManager = CookieManager(cookieJar);
    dio.interceptors.add(cookieManager);
    final List<Cookie> cookie = await cookieManager.cookieJar
        .loadForRequest(Uri.parse(ApiString.baseUrl));
    Cookie? existingBuvid3Cookie;
    for (final Cookie item in cookie) {
      if (item.name == 'buvid3' && item.value.isNotEmpty) {
        existingBuvid3Cookie = item;
        break;
      }
    }

    if (existingBuvid3Cookie != null) {
      buvid = existingBuvid3Cookie.value;
      await SPStorage.localCache.put(LocalCacheKey.buvid3, buvid);
    } else {
      final Cookie buvid3Cookie =
          _createBuvid3Cookie(await instance().getBuvid());
      await cookieManager.cookieJar.saveFromResponse(
        Uri.parse(ApiString.mainUrl),
        [buvid3Cookie],
      );
      cookie.add(buvid3Cookie);
    }
    final String cookieString = cookie
        .map((Cookie cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');
    print("Cookie: $cookieString");
    dio.options.headers['cookie'] = cookieString;
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

  Future<String> getBuvid() async {
    if (buvid != null && buvid!.isNotEmpty) {
      return buvid!;
    }

    final dynamic cachedBuvid = SPStorage.localCache.get(LocalCacheKey.buvid3);
    if (cachedBuvid is String && cachedBuvid.isNotEmpty) {
      buvid = cachedBuvid;
      return buvid!;
    }

    buvid = _generateBuvid3();
    await SPStorage.localCache.put(LocalCacheKey.buvid3, buvid);
    return buvid!;
  }

  static Cookie _createBuvid3Cookie(String value) {
    return Cookie('buvid3', value)
      ..domain = '.bilibili.com'
      ..path = '/'
      ..httpOnly = false;
  }

  static String _generateBuvid3() {
    final String suffix = _random.nextInt(100000).toString().padLeft(5, '0');
    return '${const Uuid().v4().toUpperCase()}${suffix}infoc';
  }

  //get请求
  Future<Response> get(
      {required String path,
      Object? data,
      Map<String, dynamic>? param,
      Options? options,
      CancelToken? cancelToken,
      extra}) async {
    print(path);
    print(param);
    final Options requestOptions = options ?? Options();
    if (extra != null) {
      requestOptions.responseType =
          extra!['resType'] ?? requestOptions.responseType ?? ResponseType.json;
      if (extra['ua'] != null) {
        requestOptions.headers = {
          ...?requestOptions.headers,
          'user-agent': headerUa(type: extra['ua']),
        };
      }
    } else {
      requestOptions.responseType ??= ResponseType.json;
    }
    return dio.get(
      path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: requestOptions,
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
    Response res = await dio.get(
      path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
            headers: {
              'user-agent': headerUa(),
              'referer': 'https://www.bilibili.com/',
            },
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
    return dio.post(
      path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
            headers: {
              'user-agent': headerUa(),
              'referer': 'https://www.bilibili.com/',
            },
            method: HttpMethods.post,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
  }

  String headerUa({type = 'mob'}) {
    String headerUa = '';
    if (type == 'mob') {
      if (Platform.isIOS) {
        headerUa =
            'Mozilla/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1 Mobile/15E148 Safari/604.1';
      } else {
        headerUa =
            'Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Mobile Safari/537.36';
      }
    } else {
      headerUa =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15';
    }
    return headerUa;
  }
}
