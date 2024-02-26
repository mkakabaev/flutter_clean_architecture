import 'package:mk_clean_architecture/features/posts/posts.dart';
import 'package:json_annotation/json_annotation.dart';

import 'post_dto.dart';

part 'posts_dto.g.dart';

@JsonSerializable()
class PostsDto {
  PostsDto({
    this.posts = const [],
  });

  final List<PostDto> posts;

  factory PostsDto.fromJson(Map<String, dynamic> json) => _$PostsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PostsDtoToJson(this);
}

extension PostsDtoMapper on PostsDto {
  Posts toPosts() => Posts(
        posts: posts.map((e) => e.toPost()).toList(),
      );
}
