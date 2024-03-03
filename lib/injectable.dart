import 'package:injectable/injectable.dart';

import 'package:mk_clean_architecture/core/core.dart';

import 'injectable.config.dart';

@InjectableInit()
void configureDependencies() => getIt.init();
