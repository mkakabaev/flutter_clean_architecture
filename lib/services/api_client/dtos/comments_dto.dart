import 'package:json_annotation/json_annotation.dart';

part 'comments_dto.g.dart';

@JsonSerializable()
class CommentsDto {
  CommentsDto({
    required this.string1,
    this.optionalBool = false,
    this.conditionalString1 = "",
  });

  @JsonKey(required: true)
  final String string1;

  @JsonKey(name: 'other_key', defaultValue: false)
  final bool optionalBool;

  @JsonKey(includeFromJson: false, includeToJson: true)
  final String conditionalString1;

  factory CommentsDto.fromJson(Map<String, dynamic> json) => _$CommentsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CommentsDtoToJson(this);
}
