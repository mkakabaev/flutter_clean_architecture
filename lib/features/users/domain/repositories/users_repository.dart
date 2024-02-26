import 'package:mk_clean_architecture/core/core.dart';

import '../entities/user.dart';

abstract interface class UsersRepository {
  Future<ValueState<User>> reloadMyUser();
  FutureResult<void> updateMyUser({required User user, required bool submitToBackend});
  ValueStream<ValueState<User>> get myUser;
}
