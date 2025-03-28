import 'package:json_annotation/json_annotation.dart';
part 'root_data.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class Rootdata<T> {
  int code;
  String message;
  int ttl;
  T data;

  Rootdata({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory Rootdata.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) => _$RootdataFromJson(json, fromJsonT);
}
