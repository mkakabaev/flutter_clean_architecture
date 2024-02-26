import 'package:json_annotation/json_annotation.dart';

part 'error_dto.g.dart';

@JsonSerializable()
class ErrorDto {
  const ErrorDto({
    required this.message,
    this.name,
    this.expiredAt,
  });

  @JsonKey(required: true, name: 'message')
  final String message;

  // These are actually returned by the server during JWT token processing
  final String? name;
  final String? expiredAt;

  factory ErrorDto.fromJson(Map<String, dynamic> json) => _$ErrorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorDtoToJson(this);
}
