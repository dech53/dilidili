class ApiString {
  static const String mainUrl = 'https://www.bilibili.com';
  static const String baseUrl = "https://api.bilibili.com";
  static const String live_base = "https://api.live.bilibili.com";
  static const String passportUrl = "https://passport.bilibili.com";
  static const String getRcmdVideo = "/x/web-interface/wbi/index/top/feed/rcmd";
  static const String getRelatedVideo = "/x/web-interface/archive/related";
  static const String navInterface = "/x/web-interface/nav";
  static const String apply_QRCode = "/x/passport-login/web/qrcode/generate";
  static const String check_QRCode = "/x/passport-login/web/qrcode/poll";
  static const String user_info = "/x/web-interface/card";
  static const String video_playurl = "/x/player/wbi/playurl";
  static const String video_online_people = "/x/player/online/total";
  static const String video_basic_info = "/x/web-interface/view";
  static const String video_desc_info = "/x/web-interface/archive/desc";
  static const String hotList = '/x/web-interface/popular';
  static const String hasFollow = '/x/relation';
  static const String relationMod = '/x/relation/modify';
  static const String hasLikeVideo = '/x/web-interface/archive/has/like';
  static const String hasCoinVideo = '/x/web-interface/archive/coins';
  static const String hasFavVideo = '/x/v2/fav/video/favoured';
  static const String likeVideo = '/x/web-interface/archive/like';
  static const String coinVideo = '/x/web-interface/coin/add';
  static const String favVideo = '/x/v3/fav/resource/deal';
  //收藏夹所有信息
  static const String videoInFolder = '/x/v3/fav/folder/created/list-all';
  // 我的关注 - 正在直播
  static const String getFollowingLive = '/xlive/web-ucenter/user/following';
  // 直播推荐
  static const String getliveRecommend = '/xlive/web-interface/v1/webMain/getMoreRecList';
}
