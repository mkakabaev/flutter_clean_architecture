import 'package:json_annotation/json_annotation.dart';

part 'saved_credentials_dto.g.dart';

@JsonSerializable()
class SavedCredentialsDto {
  SavedCredentialsDto({
    required this.userId,
    required this.token,
  });

  final int userId;

  @JsonKey(required: true)
  final String token;

  factory SavedCredentialsDto.fromJson(Map<String, dynamic> json) => _$SavedCredentialsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SavedCredentialsDtoToJson(this);
}
