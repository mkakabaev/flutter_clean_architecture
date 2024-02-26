import 'package:mk_clean_architecture/core/core.dart';

import '../entities/credentials_hint.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetCredentialsHintUseCase {
  final AuthRepository _repository;

  const GetCredentialsHintUseCase(this._repository);

  FutureResult<CredentialsHint?> call() => _repository.getCredentialsHint();
}
