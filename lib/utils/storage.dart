import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../model/user/info.dart';

class SPStorage {
  static late final String userID;
  static late final Box<dynamic> userInfo;
  static late final SharedPreferencesInstance prefs;
  static late double statusBarHeight;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter('${dir.path}/hive');
    Hive.registerAdapter(UserInfoDataAdapter());
    Hive.registerAdapter(LevelInfoAdapter());
    // 登录用户信息
    userInfo = await Hive.openBox(
      'userInfo',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 2;
      },
    );
    prefs = await SharedPreferencesInstance.instance();
    if (userInfo.get('userInfoCache') != null) {
      userID = userInfo.get('userInfoCache').mid.toString();
    }
  }
}
