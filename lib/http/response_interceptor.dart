import 'package:dilidili/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: unused_local_variable
    String errorMessage = "请检查网络";
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      errorMessage = "连接超时,请检查网络连接";
    } else if (err.type == DioExceptionType.receiveTimeout) {
      errorMessage = "服务器响应超时,请稍后尝试";
    } else if (err.response?.statusCode == 404) {
      errorMessage = "请求地址不存在";
    } else if (err.type == DioExceptionType.unknown) {
      errorMessage = "未知错误,请重试";
    }
    debugPrint(errorMessage);
    ToastUtils.showErrorMessage(errorMessage);
    return handler.next(err);
  }
}
