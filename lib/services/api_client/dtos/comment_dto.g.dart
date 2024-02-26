// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['string1'],
  );
  return CommentDto(
    string1: json['string1'] as String,
    optionalBool: json['other_key'] as bool? ?? false,
  );
}

Map<String, dynamic> _$CommentDtoToJson(CommentDto instance) =>
    <String, dynamic>{
      'string1': instance.string1,
      'other_key': instance.optionalBool,
      'conditionalString1': instance.conditionalString1,
    };
