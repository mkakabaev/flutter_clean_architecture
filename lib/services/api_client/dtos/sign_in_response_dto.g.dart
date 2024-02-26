// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResponseDto _$SignInResponseDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['username', 'token', 'id'],
  );
  return SignInResponseDto(
    username: json['username'] as String,
    token: json['token'] as String,
    userId: json['id'] as int,
  );
}

Map<String, dynamic> _$SignInResponseDtoToJson(SignInResponseDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'token': instance.token,
      'id': instance.userId,
    };
