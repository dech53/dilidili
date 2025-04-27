import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:dilidili/utils/regex_utils.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dio/dio.dart';

class WbiUtils {
  static final List<int> mixinKeyEncTab = <int>[
    46,
    47,
    18,
    2,
    53,
    8,
    23,
    32,
    15,
    50,
    10,
    31,
    58,
    3,
    45,
    35,
    27,
    43,
    5,
    49,
    33,
    9,
    42,
    19,
    29,
    28,
    14,
    39,
    12,
    38,
    41,
    13,
    37,
    48,
    7,
    16,
    24,
    55,
    40,
    61,
    26,
    17,
    0,
    1,
    60,
    51,
    30,
    4,
    22,
    25,
    54,
    21,
    56,
    59,
    6,
    63,
    57,
    62,
    11,
    36,
    20,
    34,
    44,
    52
  ];
  //根据传入的参数返回带wbi签名的参数
  static Future<Map<String, dynamic>> getWbi(
      Map<String, dynamic> params) async {
    final prefs = SPStorage.prefs;
    String img_key = prefs.getString("img_key") ?? "";
    String sub_key = prefs.getString("sub_key") ?? "";
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final storedDateStr = prefs.getString("img_sub_created_at");
    DateTime? storedDate;
    if (storedDateStr != null) {
      try {
        storedDate = DateTime.parse(storedDateStr);
      } catch (e) {
        Logutils.println("parse stored date failed");
      }
    }
    //从shared_preference中获取两个key，如果获取不到则表明不存在,由于wbi的当天有效性,重新set时还需要校验时间
    if (img_key == "" || sub_key == "" || !_isSameDay(storedDate, today)) {
      Response res = await DioInstance.instance()
          .get(path: ApiString.baseUrl + ApiString.navInterface);
      NavUserInfo data = Rootdata.fromJson(
        res.data,
        (dynamic data) => NavUserInfo.fromJson(data),
      ).data;
      img_key = RegexUtils.extractWbiKey(data.wbi_img.img_url);
      sub_key = RegexUtils.extractWbiKey(data.wbi_img.sub_url);
      Logutils.println("recreate key");
      prefs.setString("img_key", img_key);
      prefs.setString("sub_key", sub_key);
      prefs.setString("img_sub_created_at", DateTime.now().toIso8601String());
    }
    final String mixin_key = getMixinKey(img_key + sub_key);
    var signedParams = signParams(params, mixin_key);
    Logutils.println(signedParams.toString());
    return signedParams;
  }

  //比较日期看是否需要重新获取key
  static bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  //生成加密key
  static String getMixinKey(String orig) {
    String temp = '';
    for (int i = 0; i < mixinKeyEncTab.length; i++) {
      temp += orig.split('')[mixinKeyEncTab[i]];
    }
    return temp.substring(0, 32);
  }

  //生成w_rid
  static Map<String, dynamic> signParams(
    Map<String, dynamic> params,
    String mixinKey,
  ) {
    final List<String> query = <String>[];
    final RegExp chrFilter = RegExp(r"[!\'\(\)*]");
    final wts = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final Map<String, dynamic> newParams = Map.from(params)
      ..addAll({"wts": wts});
    for (String i in newParams.keys.toList()) {
      query.add(
          '${Uri.encodeComponent(i)}=${Uri.encodeComponent(newParams[i].toString().replaceAll(chrFilter, ''))}');
    }
    final String queryStr = query.join('&');
    final w_rid = md5.convert(utf8.encode(queryStr + mixinKey)).toString();
    newParams.addAll({'w_rid': w_rid});
    return newParams;
  }
}
