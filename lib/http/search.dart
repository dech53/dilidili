import 'dart:convert';

import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/search/all.dart';
import 'package:dilidili/model/search/hot.dart';
import 'package:dilidili/model/search/result.dart';
import 'package:dilidili/model/search/suggest.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/utils/wbi_utils.dart';

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

  static Future<Map<String, dynamic>> searchCount(
      {required String keyword}) async {
    final dynamic res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.searchCount,
      param: await WbiUtils.getWbi(
        {
          'keyword': keyword,
          'web_location': 333.999,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': SearchAllModel.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': '请求错误',
      };
    }
  }

  // 分类搜索
  static Future searchByType({
    required SearchType searchType,
    required String keyword,
    required page,
    String? order,
    int? duration,
    int? tids,
  }) async {
    var reqData = {
      'search_type': searchType.type,
      'keyword': keyword,
      // 'order_sort': 0,
      // 'user_type': 0,
      'page': page,
      if (order != null) 'order': order,
      if (duration != null) 'duration': duration,
      if (tids != null && tids != -1) 'tids': tids,
    };
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.searchByType,
      param: reqData,
    );
    if (res.data['code'] == 0) {
      if (res.data['data']['numPages'] == 0) {
        return {'status': true, 'data': Data()};
      }
      Object data;
      try {
        switch (searchType) {
          case SearchType.video:
            data = SearchVideoModel.fromJson(res.data['data']);
            break;
          case SearchType.live_room:
            data = SearchLiveModel.fromJson(res.data['data']);
            break;
          case SearchType.bili_user:
            data = SearchUserModel.fromJson(res.data['data']);
            break;
          case SearchType.media_bangumi:
            data = SearchMBangumiModel.fromJson(res.data['data']);
            break;
          case SearchType.article:
            data = SearchArticleModel.fromJson(res.data['data']);
            break;
        }
        return {
          'status': true,
          'data': data,
        };
      } catch (err) {
        return {'status': false, 'data': Data()};
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future<int> ab2c({int? aid, String? bvid}) async {
    Map<String, dynamic> data = {};
    if (aid != null) {
      data['aid'] = aid;
    } else if (bvid != null) {
      data['bvid'] = bvid;
    }
    final dynamic res = await DioInstance.instance().get(
        path: ApiString.baseUrl + ApiString.ab2c,
        param: <String, dynamic>{...data});
    if (res.data['code'] == 0) {
      return res.data['data'].first['cid'];
    } else {
      return -1;
    }
  }
}

class Data {
  List<dynamic> list;

  Data({this.list = const []});
}
