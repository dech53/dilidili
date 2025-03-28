import 'package:json_annotation/json_annotation.dart';
part 'nav_user_info.g.dart';
@JsonSerializable(explicitToJson: true)
class NavUserInfo {
  bool isLogin;
  WbiImg wbi_img;
  NavUserInfo({required this.isLogin, required this.wbi_img});
  factory NavUserInfo.fromJson(Map<String, dynamic> json)=>_$NavUserInfoFromJson(json);
  Map<String,dynamic> toJson()=>_$NavUserInfoToJson(this);
}
@JsonSerializable(explicitToJson: true)
class WbiImg {
  String img_url;
  String sub_url;
  WbiImg({required this.img_url, required this.sub_url});
  factory WbiImg.fromJson(Map<String,dynamic> json) => _$WbiImgFromJson(json);
  Map<String,dynamic> toJson()=>_$WbiImgToJson(this);
}
