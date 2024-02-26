import 'package:equatable/equatable.dart';

import 'post.dart';

class Posts extends Equatable {
  final List<Post> posts;
  const Posts({
    required this.posts,
  });

  @override
  List<Object?> get props => [posts];
}
