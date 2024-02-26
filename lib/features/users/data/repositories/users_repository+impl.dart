import 'dart:async';

import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/auth/auth.dart';
import 'package:mk_clean_architecture/services/api_client/api_client.dart';
import 'package:mk_kit/mk_kit.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';

@LazySingleton(as: UsersRepository)
class UsersRepositoryImpl implements UsersRepository {
  final _disposeBag = DisposeBag();
  final AuthorizedApiClient _apiClient;
  late final ValueStateHost<User> _myUserHost;

  UsersRepositoryImpl(this._apiClient) {
    _myUserHost = ValueStateHost(() async {
      try {
        return (await _apiClient.getMyUser()).map((r) => r.toUser());
      } catch (e, s) {
        return FutureResult.error(e, s);
      }
    });

    _disposeBag.subscriptions <<
        getIt<GetAuthSessionUseCase>()().map((s) => s.isSignedIn).distinct().listen((isSignedIn) {
          if (!isSignedIn) {
            _myUserHost.reset();
          }
        });
  }

  @override
  ValueStream<ValueState<User>> get myUser => _myUserHost.valueStream;

  @override
  FutureResult<void> updateMyUser({required User user, required bool submitToBackend}) async {
    _myUserHost.updateLoaded(user);
    return Result.value(null);
  }

  @override
  Future<ValueState<User>> reloadMyUser() => _myUserHost.reload();
}
