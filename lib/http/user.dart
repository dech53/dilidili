import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/message/unread.dart';
import 'package:dilidili/model/user/fav_folder.dart';
import 'package:dilidili/model/user/info.dart';
import 'package:dilidili/model/user/stat.dart';

class UserHttp {
  static Future hasFollow(int mid) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.hasFollow,
      param: {
        'fid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<dynamic> userInfo() async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.navInterface);
    if (res.data['code'] == 0) {
      UserInfoData data = UserInfoData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<dynamic> userStatOwner() async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.userStatOwner,
    );
    if (res.data['code'] == 0) {
      UserStat data = UserStat.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  static Future<dynamic> getUnreadMsg() async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseMsgUrl + ApiString.whisper_unread,
    );
    if (res.data['code'] == 0) {
      UnreadMsgCount data = UnreadMsgCount.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 收藏夹
  static Future<dynamic> userfavFolder({
    required int pn,
    required int ps,
    required int mid,
  }) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.userFavFolder, param: {
      'pn': pn,
      'ps': ps,
      'up_mid': mid,
    });
    if (res.data['code'] == 0) {
      late FavFolderData data;
      if (res.data['data'] != null) {
        data = FavFolderData.fromJson(res.data['data']);
        return {'status': true, 'data': data};
      } else {
        return {'status': false, 'msg': '收藏夹为空'};
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
        'code': res.data['code'],
      };
    }
  }
}
