import 'package:mk_clean_architecture/core/core.dart';

import '../entities/sign_in_request.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  FutureResult<void> call(SignInRequest request) => _repository.signIn(request);
}
