import 'package:mk_clean_architecture/core/core.dart';

import '../entities/app_bootstrap_state.dart';
import '../repositories/app_bootstrap_repository.dart';

@injectable
class GetAppBootstrapStateUseCase {
  final AppBootstrapRepository _repository;

  const GetAppBootstrapStateUseCase(this._repository);

  Stream<AppBootstrapState> call() => _repository.bootstrapState;
}
