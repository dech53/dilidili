// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrCode _$QrCodeFromJson(Map<String, dynamic> json) => QrCode(
      url: json['url'] as String,
      qrcode_key: json['qrcode_key'] as String,
    );

Map<String, dynamic> _$QrCodeToJson(QrCode instance) => <String, dynamic>{
      'url': instance.url,
      'qrcode_key': instance.qrcode_key,
    };

QrCodeState _$QrCodeStateFromJson(Map<String, dynamic> json) => QrCodeState(
      url: json['url'] as String,
      refresh_token: json['refresh_token'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$QrCodeStateToJson(QrCodeState instance) =>
    <String, dynamic>{
      'url': instance.url,
      'refresh_token': instance.refresh_token,
      'timestamp': instance.timestamp,
      'code': instance.code,
      'message': instance.message,
    };
