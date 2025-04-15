import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/member/folder_info.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/utils/wbi_utils.dart';

class MemberHttp {
  static Future memberInfo({
    int? mid,
    String token = '',
  }) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.memberInfo,
      param: await WbiUtils.getWbi(
        {
          'mid': mid,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': MemberInfo.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberStat({int? mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.userStat,
      param: {
        'vmid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取up播放数、点赞数
  static Future memberView({required int mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.getMemberViewApi,
      param: {'mid': mid},
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future getUserFolder({required int mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.getUserFolder,
      param: {
        'up_mid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']['list']
            .map<FolderItem>((e) => FolderItem.fromJson(e))
            .toList(),
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
