// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostsDto _$PostsDtoFromJson(Map<String, dynamic> json) => PostsDto(
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => PostDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PostsDtoToJson(PostsDto instance) => <String, dynamic>{
      'posts': instance.posts,
    };
