// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rootdata<T> _$RootdataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Rootdata<T>(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      ttl: (json['ttl'] as num).toInt(),
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$RootdataToJson<T>(
  Rootdata<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'ttl': instance.ttl,
      'data': toJsonT(instance.data),
    };
