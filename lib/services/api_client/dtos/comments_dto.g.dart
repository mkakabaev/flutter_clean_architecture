// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsDto _$CommentsDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['string1'],
  );
  return CommentsDto(
    string1: json['string1'] as String,
    optionalBool: json['other_key'] as bool? ?? false,
  );
}

Map<String, dynamic> _$CommentsDtoToJson(CommentsDto instance) =>
    <String, dynamic>{
      'string1': instance.string1,
      'other_key': instance.optionalBool,
      'conditionalString1': instance.conditionalString1,
    };
