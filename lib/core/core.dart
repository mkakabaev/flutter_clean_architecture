import 'package:get_it/get_it.dart';

export 'src/error.dart';
export 'src/logging.dart';
export 'src/result.dart';
export 'src/routing/route_utils.dart';
export 'src/stream_utils.dart';
export 'src/object_state.dart';
export 'src/widgets/page/page.dart';
export 'src/widgets/widgets.dart';
export 'src/validation.dart';
export 'src/worker.dart';

// We need this everywhere so we export is here
export 'package:async/async.dart' show Result, AsyncCache;
export 'package:rxdart/rxdart.dart' show ValueStream, BehaviorSubject, PublishSubject;
export 'package:injectable/injectable.dart' show injectable, LazySingleton, Singleton;

final getIt = GetIt.instance;
