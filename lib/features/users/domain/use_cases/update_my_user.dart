import 'package:mk_clean_architecture/core/core.dart';

import '../entities/user.dart';
import '../repositories/users_repository.dart';

@injectable
class UpdateMyUserUseCase {
  final UsersRepository _repository;

  const UpdateMyUserUseCase(this._repository);

  FutureResult<void> call({
    required User user,
    required bool submitToBackend,
  }) =>
      _repository.updateMyUser(user: user, submitToBackend: submitToBackend);
}
