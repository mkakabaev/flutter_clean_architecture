import 'package:mk_clean_architecture/core/core.dart';

import '../entities/user.dart';
import '../repositories/users_repository.dart';

@injectable
class ReloadMyUserUseCase {
  final UsersRepository _repository;

  const ReloadMyUserUseCase(this._repository);

  Future<ValueState<User>> call() => _repository.reloadMyUser();
}
