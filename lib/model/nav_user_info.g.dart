// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavUserInfo _$NavUserInfoFromJson(Map<String, dynamic> json) => NavUserInfo(
      isLogin: json['isLogin'] as bool,
      wbi_img: WbiImg.fromJson(json['wbi_img'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NavUserInfoToJson(NavUserInfo instance) =>
    <String, dynamic>{
      'isLogin': instance.isLogin,
      'wbi_img': instance.wbi_img.toJson(),
    };

WbiImg _$WbiImgFromJson(Map<String, dynamic> json) => WbiImg(
      img_url: json['img_url'] as String,
      sub_url: json['sub_url'] as String,
    );

Map<String, dynamic> _$WbiImgToJson(WbiImg instance) => <String, dynamic>{
      'img_url': instance.img_url,
      'sub_url': instance.sub_url,
    };
