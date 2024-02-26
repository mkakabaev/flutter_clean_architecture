import 'package:mk_clean_architecture/features/posts/posts.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../features/users/users.dart';

part 'post_dto.g.dart';

@JsonSerializable()
class PostDto {
  PostDto({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.reactions,
  });

  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final int reactions;

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}

extension PostDtoMapper on PostDto {
  Post toPost() => Post(
        id: id,
        title: title,
        body: body,
        userId: UserId(userId),
        tags: tags,
      );
}
