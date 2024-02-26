// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_credentials_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedCredentialsDto _$SavedCredentialsDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['token'],
  );
  return SavedCredentialsDto(
    userId: json['userId'] as int,
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$SavedCredentialsDtoToJson(
        SavedCredentialsDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'token': instance.token,
    };
