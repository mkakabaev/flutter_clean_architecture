import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'sign_in_response_dto.g.dart';

@JsonSerializable()
class SignInResponseDto {
  const SignInResponseDto({
    required this.username,
    required this.token,
    required this.userId,
  });

  @JsonKey(required: true)
  final String username;

  @JsonKey(required: true)
  final String token;

  @JsonKey(required: true, name: 'id')
  final int userId;

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) => _$SignInResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SignInResponseDtoToJson(this);
}

FutureOr<SignInResponseDto> deserializeSignInResponseDto(Map<String, dynamic> json) => SignInResponseDto.fromJson(json);

