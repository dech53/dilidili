import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/http_methods.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/utils/header_utils.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class VideoPageViewModel extends ChangeNotifier {
  VideoItem? _video;
  VideoItem? get video  => _video;
  set video(VideoItem? new_video){
    _video = new_video;
    notifyListeners();
  }

  Future fetchVideoPlayurl(int cid, String bvid) async {
    final prefs = await SharedPreferencesInstance.instance();
    Response response = await DioInstance.instance().get(
      path: "https://api.bilibili.com/x/player/wbi/playurl",
      param: await WbiUtils.getWbi(
        {
          'bvid': bvid,
          'cid': cid,
        },
      ),
      options: Options(
        method: HttpMethods.get,
        headers: {
          'user-agent': HeaderUtil.randomHeader(),
          'cookie': 'SESSDATA=${await prefs.getString('SESSDATA')};',
        },
      ),
    );
    Logutils.println(response.data.toString());
  }
}
