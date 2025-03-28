import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:dilidili/utils/regex_utils.dart';
import 'package:dio/dio.dart';

class WbiUtils {
  static final mixinKeyEncTab = [
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
    52,
  ];
  static Future<Map<String, dynamic>> getWbi(
      Map<String, dynamic> params) async {
    final prefs = await SharedPreferencesInstance.instance();
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
    final raw_wbi_key = img_key + sub_key;
    final mixin_key = genMixinKey(raw_wbi_key);
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
  static String genMixinKey(String rawWbiKey) {
    assert(rawWbiKey.length >= 64, "rawWbiKey 长度必须至少为 64 字符");

    final mixedChars =
        mixinKeyEncTab.map((index) => rawWbiKey[index]).toList(growable: false);

    return mixedChars.join().substring(0, 32);
  }

  //生成w_rid
  static Map<String, dynamic> signParams(
    Map<String, dynamic> params,
    String mixinKey,
  ) {
    final wts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final paramsWithWts = Map<String, dynamic>.from(params)..['wts'] = wts;
    final sortedEntries = paramsWithWts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final queryString = sortedEntries.map((entry) {
      final key = Uri.encodeQueryComponent(entry.key);
      final value = Uri.encodeQueryComponent(entry.value.toString());
      return '$key=$value';
    }).join('&');
    final data = queryString + mixinKey;
    final wRid = md5.convert(utf8.encode(data)).toString();
    return Map<String, dynamic>.from(params)
      ..['w_rid'] = wRid
      ..['wts'] = wts;
  }
}
