import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/auth/auth.dart';
import 'package:mk_clean_architecture/services/api_client/api_client.dart';

import '../../domain/entities/app_bootstrap_state.dart';
import '../../domain/repositories/app_bootstrap_repository.dart';

@LazySingleton(as: AppBootstrapRepository)
class AppBootstrapRepositoryImpl implements AppBootstrapRepository {
  final GetAuthSessionUseCase _getSessionUseCase;
  final _bootstrapStateSubject = BehaviorSubject<AppBootstrapState>.seeded(AppBootstrapState.initial());

  AppBootstrapRepositoryImpl(this._getSessionUseCase) {
    _bootstrap();
  }

  @override
  Stream<AppBootstrapState> get bootstrapState => _bootstrapStateSubject.stream;

  void _bootstrap() async {
    // waiting for the user session to be ready loaded
    final auth = await _getSessionUseCase().firstOfNonType<AuthSessionInitial>();

    // Warm up the API client: starting background isolates
    initWorkers();

    // Report the state
    _bootstrapStateSubject.value = AppBootstrapStateReady(
      // initialRoute: "/",
      authenticated: auth.isSignedIn,
    );
  }
}
