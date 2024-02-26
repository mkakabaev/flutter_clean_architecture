import 'package:mk_clean_architecture/core/core.dart';

import '../entities/posts.dart';

abstract interface class PostsRepository {
  ValueStream<ValueState<Posts>> get myPosts;
  Future<ValueState<Posts>> reloadMyPosts();
}
