import 'package:mk_clean_architecture/core/core.dart';

import '../entities/user.dart';
import '../repositories/users_repository.dart';

@injectable
class GetMyUserUseCase {
  final UsersRepository _repository;

  const GetMyUserUseCase(this._repository);

  ValueStream<ValueState<User>> call() => _repository.myUser;
}
