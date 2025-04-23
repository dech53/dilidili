import 'dart:convert';

import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/search/hot.dart';
import 'package:dilidili/model/search/suggest.dart';

class SearchHttp {
  static Future hotSearchList() async {
    var res = await DioInstance.instance().get(
      path: ApiString.searchUrl + ApiString.hotSearchUrl,
    );
    if (res.data is String) {
      Map<String, dynamic> resultMap = json.decode(res.data);
      if (resultMap['code'] == 0) {
        return {
          'status': true,
          'data': HotSearchModel.fromJson(resultMap),
        };
      }
    } else if (res.data is Map<String, dynamic> && res.data['code'] == 0) {
      return {
        'status': true,
        'data': HotSearchModel.fromJson(res.data),
      };
    }
    return {
      'status': false,
      'data': [],
      'msg': '请求错误',
    };
  }

  // 获取搜索建议
  static Future searchSuggest({required term}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.searchUrl + ApiString.searchSuggestUrl,
      param: {
        'term': term,
        'main_ver': 'v1',
        'highlight': term,
      },
    );
    if (res.data is String) {
      Map<String, dynamic> resultMap = json.decode(res.data);
      if (resultMap['code'] == 0) {
        if (resultMap['result'] is Map) {
          resultMap['result']['term'] = term;
        }
        return {
          'status': true,
          'data': resultMap['result'] is Map
              ? SearchSuggestModel.fromJson(resultMap['result'])
              : [],
        };
      } else {
        return {
          'status': false,
          'data': [],
          'msg': '请求错误 🙅',
        };
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': '请求错误',
      };
    }
  }
}
