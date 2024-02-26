import 'package:mk_clean_architecture/core/core.dart';

import '../entities/posts.dart';
import '../repositories/posts_repository.dart';

@injectable
class GetPostsForUserUseCase {
  final PostsRepository _repository;

  const GetPostsForUserUseCase(this._repository);

  ValueStream<ValueState<Posts>> call() {
    final result = _repository.myPosts;
    if (result.value is ValueStateEmpty) {
      _repository.reloadMyPosts();
    }
    return result;
  }
}
