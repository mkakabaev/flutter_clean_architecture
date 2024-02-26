// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorDto _$ErrorDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['message'],
  );
  return ErrorDto(
    message: json['message'] as String,
    name: json['name'] as String?,
    expiredAt: json['expiredAt'] as String?,
  );
}

Map<String, dynamic> _$ErrorDtoToJson(ErrorDto instance) => <String, dynamic>{
      'message': instance.message,
      'name': instance.name,
      'expiredAt': instance.expiredAt,
    };
