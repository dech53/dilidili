import 'package:json_annotation/json_annotation.dart';
part 'qr_code.g.dart';

@JsonSerializable()
class QrCode {
  String url;
  String qrcode_key;
  QrCode({
    required this.url,
    required this.qrcode_key,
  });
  factory QrCode.fromJson(Map<String, dynamic> json) => _$QrCodeFromJson(json);
}

@JsonSerializable()
class QrCodeState {
  String url;
  String refresh_token;
  int timestamp;
  int code;
  String message;
  QrCodeState(
      {required this.url,
      required this.refresh_token,
      required this.timestamp,
      required this.code,
      required this.message});
  factory QrCodeState.fromJson(Map<String, dynamic> json) =>
      _$QrCodeStateFromJson(json);
}
