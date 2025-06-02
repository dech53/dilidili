class UnreadMsgCount {
  UnreadMsgCount({
    this.unfollow_unread,
    this.follow_unread,
    this.unfollow_push_msg,
    this.dustbin_push_msg,
    this.dustbin_unread,
    this.biz_msg_unfollow_unread,
    this.biz_msg_follow_unread,
    this.custom_unread,
  });
  int? unfollow_unread;
  int? follow_unread;
  int? unfollow_push_msg;
  int? dustbin_push_msg;
  int? dustbin_unread;
  int? biz_msg_unfollow_unread;
  int? biz_msg_follow_unread;
  int? custom_unread;
  UnreadMsgCount.fromJson(Map<String, dynamic> json) {
    unfollow_unread = json["unfollow_unread"];
    follow_unread = json["follow_unread"];
    unfollow_push_msg = json["unfollow_push_msg"];
    dustbin_push_msg = json["dustbin_push_msg"];
    dustbin_unread = json["dustbin_unread"];
    biz_msg_unfollow_unread = json["biz_msg_unfollow_unread"];
  }
}
