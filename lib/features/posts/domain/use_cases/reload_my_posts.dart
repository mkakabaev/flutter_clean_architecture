import 'package:mk_clean_architecture/core/core.dart';

import '../entities/posts.dart';
import '../repositories/posts_repository.dart';

@injectable
class ReloadMyPostsUseCase {
  final PostsRepository _repository;

  const ReloadMyPostsUseCase(this._repository);

  Future<ValueState<Posts>> call() => _repository.reloadMyPosts();
}
