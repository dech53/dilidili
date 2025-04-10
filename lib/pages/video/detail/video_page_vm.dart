import 'dart:io';
import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/http_methods.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/model/video_play_url.dart';
import 'package:dilidili/utils/header_utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPageViewModel extends ChangeNotifier {
  VideoPlayUrl? _videoPlayUrl;
  VideoController? _main_controller;
  UserCardInfo? _upInfo;
  VideoOnlinePeople? _onlinePeople;
  VideoDetailData? _videoData;
  List<RelatedVideoItem>? _relatedVideo;

  Player player = Player(
      configuration: const PlayerConfiguration(
    bufferSize: 5 * 1024 * 1024,
  ));
  List<RelatedVideoItem>? get relatedVideo => _relatedVideo;
  VideoDetailData? get videoData => _videoData;
  UserCardInfo? get upInfo => _upInfo;
  VideoPlayUrl? get videoPlayUrl => _videoPlayUrl;
  VideoController? get main_controller => _main_controller;
  VideoOnlinePeople? get onlinePeople => _onlinePeople;

  set relatedVideo(List<RelatedVideoItem>? data) {
    _relatedVideo = data;
    notifyListeners();
  }

  set videoData(VideoDetailData? data) {
    _videoData = data;
    notifyListeners();
  }

  set onlinePeople(VideoOnlinePeople? count) {
    _onlinePeople = count;
    notifyListeners();
  }

  set upInfo(UserCardInfo? new_upInfo) {
    _upInfo = new_upInfo;
    notifyListeners();
  }

  set main_controller(VideoController? new_main_controller) {
    _main_controller = new_main_controller;
    notifyListeners();
  }

  set videoPlayUrl(VideoPlayUrl? new_videoPlayUrl) {
    _videoPlayUrl = new_videoPlayUrl;
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
          'qn': 0,
          'fnval': 80,
          'fnver': 0,
          'fourk': 1,
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
    VideoPlayUrl res = Rootdata.fromJson(
      response.data,
      (dynamic data) => VideoPlayUrl.fromJson(data),
    ).data;
    //音轨
    if (res.dash.audio != null && res.dash.audio != []) {
      await (player.platform as NativePlayer).setProperty(
          'audio-files',
          Platform.isWindows
              ? res.dash.audio![0].baseUrl.replaceAll(';', '\\;')
              : res.dash.audio![0].baseUrl.replaceAll(':', '\\:'));
    }
    //视频流
    await player.open(
        Media(res.dash.video[0].baseUrl, httpHeaders: {
          'user-agent': HeaderUtil.randomHeader(),
          'referer': 'https://www.bilibili.com',
        }),
        play: false);
    //controller

    //确保完全加载完后再play
    if (player.state.position.inMilliseconds == 0) {
      main_controller = VideoController(
        player,
        configuration: const VideoControllerConfiguration(
          enableHardwareAcceleration: true,
          androidAttachSurfaceAfterVideoParameters: true,
        ),
      );
      await player.play();
    }
  }

  Future fetchUpInfo(int mid) async {
    final prefs = await SharedPreferencesInstance.instance();
    Response response = await DioInstance.instance().get(
      path: "https://api.bilibili.com/x/web-interface/card",
      param: {
        'mid': mid,
        'photo': false,
      },
      options: Options(
        method: HttpMethods.get,
        headers: {
          'user-agent': HeaderUtil.randomHeader(),
          'cookie': 'SESSDATA=${await prefs.getString('SESSDATA')};',
        },
      ),
    );
    upInfo = Rootdata.fromJson(
      response.data,
      (dynamic data) => UserCardInfo.fromJson(data),
    ).data;
  }

  Future fetchOnlinePeople(int cid, String bvid) async {
    Response res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.video_online_people,
      param: {'bvid': bvid, 'cid': cid},
      options: Options(
        method: HttpMethods.get,
        headers: {
          'user-agent': HeaderUtil.randomHeader(),
        },
      ),
    );
    onlinePeople = Rootdata.fromJson(
      res.data,
      (dynamic data) => VideoOnlinePeople.fromJson(data),
    ).data;
  }

  Future fetchBasicVideoInfo(int cid, String bvid) async {
    final prefs = await SharedPreferencesInstance.instance();
    Response res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.video_basic_info,
      param: {'bvid': bvid, 'cid': cid},
      options: Options(
        method: HttpMethods.get,
        headers: {
          'user-agent': HeaderUtil.randomHeader(),
          'cookie': 'SESSDATA=${await prefs.getString('SESSDATA')};',
        },
      ),
    );
    videoData = Rootdata.fromJson(
        res.data, (dynamic data) => VideoDetailData.fromJson(data)).data;
  }

  Future fetchRelatedVideo(String bvid) async {
    Response res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.getRelatedVideo,
      param: {
        'bvid': bvid,
      },
      options: Options(
        method: HttpMethods.get,
        headers: {
          'user-agent': HeaderUtil.randomHeader(),
        },
      ),
    );
    relatedVideo = (res.data['data'] as List<dynamic>)
        .map((e) => RelatedVideoItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
