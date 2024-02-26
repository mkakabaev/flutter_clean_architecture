import '../entities/app_bootstrap_state.dart';

abstract interface class AppBootstrapRepository {
  Stream<AppBootstrapState> get bootstrapState;
}
