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
  // 收藏夹
  // https://api.bilibili.com/x/v3/fav/folder/created/list?pn=1&ps=10&up_mid=17340771
  static const String userFavFolder = '/x/v3/fav/folder/created/list';
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
  static const String memberPost = '/x/space/wbi/arc/search';

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

  /// 排行榜
  static const String getRankApi = "/x/web-interface/ranking/v2";
  static const String bangumiList =
      '/pgc/season/index/result?st=1&order=3&season_version=-1&spoken_language_type=-1&area=-1&is_finish=-1&copyright=-1&season_status=-1&season_month=-1&year=-1&style_id=-1&sort=0&season_type=1&pagesize=20&type=1';

  // 我的订阅
  static const String bangumiFollow =
      '/x/space/bangumi/follow/list?type=1&follow_status=0&pn=1&ps=15&ts=1691544359969';

  static const String whisper_unread =
      '/session_svr/v1/session_svr/single_unread';

  // 正在直播的up & 关注的up
  static const String followUp = '/x/polymer/web-dynamic/v1/portal';
  // 动态点赞
  static const String likeDynamic = '/dynamic_like/v1/dynamic_like/thumb';
  // 发布复杂动态
  static const String createDynamic = '/x/dynamic/feed/create/dyn';
  static const String webDanmaku = '/x/v2/dm/web/seg.so';
  // 评论列表
  // https://api.bilibili.com/x/v2/reply/main?csrf=6e22efc1a47225ea25f901f922b5cfdd&mode=3&oid=254175381&pagination_str=%7B%22offset%22:%22%22%7D&plat=1&seek_rpid=0&type=11
  static const String replyList = '/x/v2/reply';
  // 评论点赞
  static const String likeReply = '/x/v2/reply/action';

  /// 直播间弹幕信息
  static const String getDanmuInfo = '/xlive/web-room/v1/index/getDanmuInfo';

  /// 直播间记录
  static const String liveRoomEntry =
      '/xlive/web-room/v1/index/roomEntryAction';

  /// 直播间发送弹幕
  static const String sendLiveMsg = '/msg/send';

  /// 视频相关tag
  static const String videoTag = '/x/web-interface/view/detail/tag';

  /// 记录视频播放进度
  static const String heartBeat = '/x/click-interface/web/heartbeat';
  // 用户动态
  static const String memberMoment = '/x/polymer/web-dynamic/v1/feed/space';
  // 关注的up动态
  static const String followDynamic = '/x/polymer/web-dynamic/v1/feed/all';
  /// 删除收藏夹
  static const String delFavFolder = '/x/v3/fav/folder/del';
  /// 收藏夹 详情
  /// media_id  当前收藏夹id 搜索全部时为默认收藏夹id
  /// pn int 当前页
  /// ps int pageSize
  /// keyword String 搜索词
  /// order String 排序方式 view 最多播放 mtime 最近收藏 pubtime 最近投稿
  /// tid int 分区id
  /// platform web
  /// type 0 当前收藏夹 1 全部收藏夹
  // https://api.bilibili.com/x/v3/fav/resource/list?media_id=76614671&pn=1&ps=20&keyword=&order=mtime&type=0&tid=0
  static const String userFavFolderDetail = '/x/v3/fav/resource/list';
}
