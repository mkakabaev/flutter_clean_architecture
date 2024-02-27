import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

import 'package:mk_clean_architecture/features/auth/auth.dart';
import 'package:mk_clean_architecture/features/users/users.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  UserDto({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.id,
    this.imageUrl,
  });

  @JsonKey(required: true)
  final String password;

  @JsonKey(required: true)
  final String username;

  @JsonKey(defaultValue: '')
  final String lastName;

  @JsonKey(defaultValue: '')
  final String firstName;

  @JsonKey(name: 'image', required: true)
  final String? imageUrl;

  @JsonKey(name: 'id', required: true)
  final int id;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

FutureOr<UserDto> deserializeUserDto(Map<String, dynamic> json) => UserDto.fromJson(json);

extension UserDtoMapper on UserDto {
  CredentialsHint toCredentialsHint() => CredentialsHint(
        username: username,
        password: password,
      );

  User toUser() => User(
        username: username,
        firstName: firstName,
        lastName: lastName,
        imageUrl: imageUrl,
        id: UserId(id),
      );
}
