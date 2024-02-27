import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request_dto.g.dart';

@JsonSerializable()
class SignInRequestDto {
  const SignInRequestDto({
    required this.username,
    required this.password,
    this.expirationInMinutes,
  });

  final String username;
  final String password;

  @JsonKey(name: 'expiresInMins')
  final int? expirationInMinutes;

  factory SignInRequestDto.fromJson(Map<String, dynamic> json) => _$SignInRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SignInRequestDtoToJson(this);
}

FutureOr<Map<String, dynamic>> serializeSignInRequestDto(SignInRequestDto object) => object.toJson();
