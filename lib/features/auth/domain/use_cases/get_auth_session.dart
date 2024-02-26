import 'package:mk_clean_architecture/core/core.dart';

import '../repositories/auth_repository.dart';
import '../entities/auth_session.dart';

@injectable
class GetAuthSessionUseCase {
  final AuthRepository _repository;

  GetAuthSessionUseCase(this._repository);

  Stream<AuthSession> call() => _repository.authSession;
}
