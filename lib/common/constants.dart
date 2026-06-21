import 'package:flutter/material.dart';

class StyleString {
  static const double cardSpace = 8;
  static const double safeSpace = 12;
  static BorderRadius mdRadius = BorderRadius.circular(10);
  static const Radius imgRadius = Radius.circular(8);
  static const double aspectRatio = 16 / 10;
}

class Constants {
  // 27eb53fc9058f8c3  移动端 Android
  // 4409e2ce8ffd12b8  TV端
  static const String appKey = '4409e2ce8ffd12b8';
  // 59b43e04ad6965f34319062b478f83dd TV端
  static const String appSec = '59b43e04ad6965f34319062b478f83dd';
  static const String androidAppKey = 'dfca71928277209b';
  static const String androidAppSec = 'b5475a8825547a4fc26c7d518eaaa02e';
  static const String thirdSign = '04224646d1fea004e79606d3b038c84a';
  static const String thirdApi =
      'https://www.mcbbs.net/template/mcbbs/image/special_photo_bg.png';
  // app
  static const String userAgentApp =
      'Mozilla/5.0 BiliDroid/8.43.0 (bbcallen@gmail.com) os/android model/android mobi_app/android build/8430300 channel/master innerVer/8430300 osVer/15 network/2';

  static const String statisticsApp =
      '{"appId":1,"platform":3,"version":"8.43.0","abtest":""}';
}
