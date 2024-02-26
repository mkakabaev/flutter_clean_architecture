// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['password', 'username', 'image', 'id'],
  );
  return UserDto(
    username: json['username'] as String,
    password: json['password'] as String,
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    id: json['id'] as int,
    imageUrl: json['image'] as String?,
  );
}

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'password': instance.password,
      'username': instance.username,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'image': instance.imageUrl,
      'id': instance.id,
    };
