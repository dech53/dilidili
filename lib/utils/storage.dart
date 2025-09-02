import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../model/user/info.dart';

class SPStorage {
  static late final String userID;
  static late final Box<dynamic> userInfo;
  static late final Box<dynamic> historyword;
  static late final SharedPreferencesInstance prefs;
  static late final Box<dynamic> setting;
  static late double statusBarHeight;
  static late final Box<dynamic> localCache;
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
    // 本地缓存
    localCache = await Hive.openBox(
      'localCache',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 4;
      },
    );
    // 设置
    setting = await Hive.openBox('setting');
    // 搜索历史
    historyword = await Hive.openBox(
      'historyWord',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 10;
      },
    );
    prefs = await SharedPreferencesInstance.instance();
    if (userInfo.get('userInfoCache') != null) {
      userID = userInfo.get('userInfoCache').mid.toString();
    }
  }
  static Future<void> close() async {
    // user.compact();
    // user.close();
    userInfo.compact();
    userInfo.close();
    historyword.compact();
    historyword.close();
    localCache.compact();
    localCache.close();
    setting.compact();
    setting.close();
  }
}


class SettingBoxKey {
  /// 播放器
  static const String btmProgressBehavior = 'btmProgressBehavior',
      defaultVideoSpeed = 'defaultVideoSpeed',
      autoUpgradeEnable = 'autoUpgradeEnable',
      feedBackEnable = 'feedBackEnable',
      defaultVideoQa = 'defaultVideoQa',
      defaultLiveQa = 'defaultLiveQa',
      defaultAudioQa = 'defaultAudioQa',
      autoPlayEnable = 'autoPlayEnable',
      fullScreenMode = 'fullScreenMode',
      defaultDecode = 'defaultDecode',
      danmakuEnable = 'danmakuEnable',
      defaultToastOp = 'defaultToastOp',
      defaultPicQa = 'defaultPicQa',
      enableHA = 'enableHA',
      enableOnlineTotal = 'enableOnlineTotal',
      enableAutoBrightness = 'enableAutoBrightness',
      enableAutoEnter = 'enableAutoEnter',
      enableAutoExit = 'enableAutoExit',
      p1080 = 'p1080',
      enableCDN = 'enableCDN',
      autoPiP = 'autoPiP',
      enableAutoLongPressSpeed = 'enableAutoLongPressSpeed',
      enablePlayerControlAnimation = 'enablePlayerControlAnimation',
      // 默认音频输出方式
      defaultAoOutput = 'defaultAoOutput',
      // 港澳台模式
      enableGATMode = 'enableGATMode',

      // youtube 双击快进快退
      enableQuickDouble = 'enableQuickDouble',
      enableShowDanmaku = 'enableShowDanmaku',
      enableBackgroundPlay = 'enableBackgroundPlay',
      fullScreenGestureMode = 'fullScreenGestureMode',

      /// 隐私
      blackMidsList = 'blackMidsList',

      /// 推荐
      enableRcmdDynamic = 'enableRcmdDynamic',
      defaultRcmdType = 'defaultRcmdType',
      enableSaveLastData = 'enableSaveLastData',
      minDurationForRcmd = 'minDurationForRcmd',
      minLikeRatioForRecommend = 'minLikeRatioForRecommend',
      exemptFilterForFollowed = 'exemptFilterForFollowed',
      //filterUnfollowedRatio = 'filterUnfollowedRatio',
      applyFilterToRelatedVideos = 'applyFilterToRelatedVideos',

      /// 其他
      autoUpdate = 'autoUpdate',
      replySortType = 'replySortType',
      defaultDynamicType = 'defaultDynamicType',
      enableHotKey = 'enableHotKey',
      enableQuickFav = 'enableQuickFav',
      enableWordRe = 'enableWordRe',
      enableSearchWord = 'enableSearchWord',
      enableSystemProxy = 'enableSystemProxy',
      enableAi = 'enableAi',
      defaultHomePage = 'defaultHomePage',
      enableRelatedVideo = 'enableRelatedVideo';

  /// 外观
  static const String themeMode = 'themeMode',
      defaultTextScale = 'textScale',
      dynamicColor = 'dynamicColor', // bool
      customColor = 'customColor', // 自定义主题色
      enableSingleRow = 'enableSingleRow', // 首页单列
      displayMode = 'displayMode',
      customRows = 'customRows', // 自定义列
      enableMYBar = 'enableMYBar',
      hideSearchBar = 'hideSearchBar', // 收起顶栏
      hideTabBar = 'hideTabBar', // 收起底栏
      tabbarSort = 'tabbarSort', // 首页tabbar
      dynamicBadgeMode = 'dynamicBadgeMode',
      enableGradientBg = 'enableGradientBg',
      navBarSort = 'navBarSort',
      actionTypeSort = 'actionTypeSort';
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false 记录
  static const String historyPause = 'historyPause',
      // access_key
      accessKey = 'accessKey',

      //
      wbiKeys = 'wbiKeys',
      timeStamp = 'timeStamp',

      // 弹幕相关设置 屏蔽类型 显示区域 透明度 字体大小 弹幕时间 描边粗细
      danmakuBlockType = 'danmakuBlockType',
      danmakuShowArea = 'danmakuShowArea',
      danmakuOpacity = 'danmakuOpacity',
      danmakuFontScale = 'danmakuFontScale',
      danmakuDuration = 'danmakuDuration',
      strokeWidth = 'strokeWidth',

      // 代理host port
      systemProxyHost = 'systemProxyHost',
      systemProxyPort = 'systemProxyPort';

  static const String isDisableBatteryOptLocal = 'isDisableBatteryOptLocal',
      isManufacturerBatteryOptimizationDisabled =
          'isManufacturerBatteryOptimizationDisabled';
}