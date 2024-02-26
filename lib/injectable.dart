import 'package:mk_clean_architecture/core/core.dart';
import 'package:injectable/injectable.dart';

import 'injectable.config.dart';

@InjectableInit()
void configureDependencies() => getIt.init();
