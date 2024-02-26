---
to: <%= feature_dir %>/domain/use_cases/<%= name_file %>.dart
---
import 'package:mk_clean_architecture/core/core.dart';

import '../repositories/<%= h.h2.file("repo") %>_repository.dart';

@injectable
class <%= name_type %>UseCase {
  final <%= h.h2.type("repo") %>Repository _repository;

  const <%= name_type %>UseCase(this._repository);

  FutureResult<void> call() =>  throw UnimplementedError("Implement <%= name_type %>UseCase.call()!");
}
