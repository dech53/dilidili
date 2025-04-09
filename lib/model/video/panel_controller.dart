import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/video_play_url.dart';

class PanelController {
  VideoItem? video;
  VideoPlayUrl? videoPlayUrl;
  VideoOnlinePeople? onlinePeople;
  UserCardInfo? upInfo;
  PanelController(
      {this.video, this.videoPlayUrl, this.onlinePeople, this.upInfo});
  PanelController copyWith({
    VideoItem? video,
    VideoPlayUrl? videoPlayUrl,
    VideoOnlinePeople? onlinePeople,
    UserCardInfo? upInfo,
  }) {
    return PanelController(
      video: video ?? this.video,
      videoPlayUrl: videoPlayUrl ?? this.videoPlayUrl,
      onlinePeople: onlinePeople ?? this.onlinePeople,
      upInfo: upInfo ?? this.upInfo,
    );
  }
}
