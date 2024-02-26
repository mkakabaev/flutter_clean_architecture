import 'package:mk_clean_architecture/core/core.dart';

import '../entities/posts.dart';
import '../repositories/posts_repository.dart';

@injectable
class GetMyPostsUseCase {
  final PostsRepository _repository;

  const GetMyPostsUseCase(this._repository);

  ValueStream<ValueState<Posts>> call() => _repository.myPosts;
}
