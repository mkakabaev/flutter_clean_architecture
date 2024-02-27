import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';
part 'users_dto.g.dart';

@JsonSerializable()
class UsersDto {
  UsersDto({
    this.users = const [],
  });

  final List<UserDto> users;

  factory UsersDto.fromJson(Map<String, dynamic> json) => _$UsersDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UsersDtoToJson(this);
}

FutureOr<UsersDto> deserializeUsersDto(Map<String, dynamic> json) => UsersDto.fromJson(json);
