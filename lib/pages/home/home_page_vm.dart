import 'dart:math';

import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/http_methods.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/utils/header_utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/*引入cookiejar管理cookie */
class HomePageViewModel extends ChangeNotifier {
  List<VideoItem>? _videoItems;
  int _currentPage = Random().nextInt(1000);
  List<VideoItem>? get videoItems => _videoItems;
  set videoItems(List<VideoItem>? videoItems) {
    _videoItems = videoItems;
    notifyListeners();
  }

  set currentPage(int currentPage) {
    _currentPage = currentPage;
  }

  Future fetchVideos({bool refresh = false}) async {
    final prefs = await SharedPreferencesInstance.instance();
    Response response = await DioInstance.instance().get(
        path: ApiString.baseUrl + ApiString.getRcmdVideo,
        param: await WbiUtils.getWbi(
          {
            "fresh_idx": _currentPage,
          },
        ),
        options: Options(method: HttpMethods.get, headers: {
          'user-agent': HeaderUtil.randomHeader(),
          'cookie': 'SESSDATA=${prefs.getString('SESSDATA')};',
        }));
    RcmdVideo parsedData = Rootdata.fromJson(
      response.data,
      (dynamic data) => RcmdVideo.fromJson(data),
    ).data;
    if (refresh || _videoItems == null) {
      videoItems = parsedData.item;
      currentPage = Random().nextInt(1000);
    } else {
      videoItems = [..._videoItems!, ...parsedData.item];
      currentPage = _currentPage + 1;
    }
  }
}
