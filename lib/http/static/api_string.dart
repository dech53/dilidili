class ApiString {
  static const String baseMsgUrl = 'https://api.vc.bilibili.com';
  static const String searchUrl = 'https://s.search.bilibili.com';
  static const String hotSearchUrl = '/main/hotword';
  static const String searchSuggestUrl = '/main/suggest';
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
  static const String getliveRecommend =
      '/xlive/web-interface/v1/webMain/getMoreRecList';
  //用户信息
  static const String memberInfo = '/x/space/wbi/acc/info';
  //用户关注数和粉丝数
  static const String userStat = '/x/relation/stat';
  //用户获赞数、播放数
  static const String getMemberViewApi = '/x/space/upstat';
  // 查询用户与自己关系_仅查关注
  static const String hasFollow = '/x/relation';
  //查询用户公开收藏夹
  //传入up_mid,用户id
  static const String getUserFolder = '/x/v3/fav/folder/created/list-all';
  //查询收藏夹元数据,收藏夹封面图
  //传入media_id,收藏夹id
  static const String getFolerDetail = '/x/v3/fav/folder/info';
  //获取收藏夹内容明细
  //传入media_id、ps(页数)
  static const String getFolerContent = '/x/v3/fav/resource/list';
  // 用户投稿
  // https://api.bilibili.com/x/space/wbi/arc/search?
  // mid=85754245&
  // ps=30&
  // tid=0&
  // pn=1&
  // keyword=&
  // order=pubdate&
  // platform=web&
  // web_location=1550101&
  // order_avoided=true&
  // w_rid=d893cf98a4e010cf326373194a648360&
  // wts=1689767832
  static const String memberArchive = '/x/space/wbi/arc/search';

  /// 搜索结果计数
  static const String searchCount = '/x/web-interface/wbi/search/all/v2';

  // 分类搜索
  static const String searchByType = '/x/web-interface/wbi/search/type';

  // 查询视频分P列表 (avid/bvid转cid)
  static const String ab2c = '/x/player/pagelist';

  static const String sessionList = '/session_svr/v1/session_svr/get_sessions';

  /// 私聊用户信息
  /// uids
  /// build=0&mobi_app=web
  static const String sessionAccountList = '/account/v1/user/cards';

  /// 消息未读数
  static const String unread = '/x/im/web/msgfeed/unread';
  static const String sessionMsg = '/svr_sync/v1/svr_sync/fetch_session_msgs';

  /// 发送私信
  static const String sendMsg = '/web_im/v1/web_im/send_msg';
  // 直播间详情 H5
  static const String liveRoomInfoH5 =
      '/xlive/web-room/v1/index/getH5InfoByRoom';
  // 直播间详情
  // cid roomId
  // qn 80:流畅，150:高清，400:蓝光，10000:原画，20000:4K, 30000:杜比
  static const String liveRoomInfo = '/xlive/web-room/v2/index/getRoomPlayInfo';
  // 获取当前用户状态
  static const String userStatOwner = '/x/web-interface/nav/stat';
}
