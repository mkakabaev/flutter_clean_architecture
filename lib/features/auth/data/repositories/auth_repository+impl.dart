import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/users/users.dart';
import 'package:mk_clean_architecture/services/api_client/api_client.dart';
import 'package:mk_clean_architecture/services/secure_storage/secure_storage.dart';
import 'package:mk_kit/mk_kit.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/credentials_hint.dart';
import '../../domain/entities/sign_in_request.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dtos/saved_credentials_dto.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl with LoggerObject, DescriptionProvider implements AuthRepository {
  final ApiClient _api;
  final AuthorizedApiClient _authorizedApi;
  final SecureStorage _secureStorage;
  final _disposeBag = DisposeBag();
  final _sessionSubject = BehaviorSubject<AuthSession>.seeded(const AuthSession.initial());

  AuthRepositoryImpl(this._api, this._authorizedApi, this._secureStorage) {
    // We subscribe to the errors of the authorized API to catch the unauthorized errors and
    // sign out the user automatically. This way we will check the session state on every request
    // that AuthorizedApiClient produces upon other features requests
    _disposeBag.subscriptions <<
        _authorizedApi.errors.listen((error) {
          if (error.type == MyErrorType.unauthorized) {
            signOut();
          }
        });

    _disposeBag.subscriptions <<
        _authorizedApi.refreshedCredentials
            .listen((c) => saveCredentials(SavedCredentialsDto(userId: c.userId, token: c.token)));

    _init();
  }

  void _init() async {
    // Loading saved credentials. Upon completion we will have either signed in user or not
    // We do not check the restored credentials for validness, because the authorized API will do it on the
    // very first request
    final credentials = await loadCredentials();

    // No credentials was found or properly restored. We are signed out
    if (credentials == null) {
      _sessionSubject.add(const AuthSession.signedOut());
      return;
    }

    // Successfully restored the credentials. Set the bearer token for the authorized requests
    _authorizedApi.setCredentials((token: credentials.token, userId: credentials.userId));
    _sessionSubject.add(const AuthSession.signedIn());
  }

  @override
  Stream<AuthSession> get authSession => _sessionSubject;

  @override
  Future<void> signOut() async {
    if (!_sessionSubject.value.isSignedIn) {
      return;
    }

    // Clear the saved credentials, Reset the bearer token for the authorized requests
    await saveCredentials(null);
    _authorizedApi.setCredentials(null);

    _sessionSubject.add(const AuthSession.signedOut());
  }

  @override
  FutureResult<void> signIn(SignInRequest request) async {
    final result = await _api.signIn(SignInRequestDto(
      username: request.username,
      password: request.password,
      expirationInMinutes: 60 * 24 * 30, // 30 days, this is the max for the demo
    ));

    // Successfully signed in
    if (result.isValue) {
      var (signInDto, userDto) = result.requiredValue;

      // Set the bearer token for the subsequent authorized requests, save the credentials
      _authorizedApi.setCredentials((token: signInDto.token, userId: signInDto.userId));
      await saveCredentials(SavedCredentialsDto(userId: signInDto.userId, token: signInDto.token));

      // Pass receives user data to the user repository fpr an immediate update
      getIt<UpdateMyUserUseCase>()(user: userDto.toUser(), submitToBackend: false);

      // Mark session opened. This may trigger the UI to update the session state
      // Also, this may trigger the dependent repositories to start updating the data
      _sessionSubject.add(const AuthSession.signedIn());
    }

    return result.asVoid;
  }

  // This is a simplest cache for the credentials hint. Just as a demonstration
  final _credentialsHintCache = AsyncCache<Result<CredentialsHint?>>(const Duration(seconds: 10));

  @override
  FutureResult<CredentialsHint?> getCredentialsHint() async {
    final result = await _credentialsHintCache.fetch(() async {
      final result = await _api.getRandomUser();
      return result.map((dto) => dto?.toCredentialsHint());
    });
    if (result.asValue?.value == null) {
      _credentialsHintCache.invalidate(); // we cache only successful attempt
    }
    return result;
  }
}

extension on AuthRepositoryImpl {
  static const _savedCredentialsStoredKey = 'auth';

  Future<void> saveCredentials(SavedCredentialsDto? credentials) async {
    await _secureStorage.setJson(_savedCredentialsStoredKey, credentials?.toJson());
  }

  Future<SavedCredentialsDto?> loadCredentials() async {
    try {
      final map = await _secureStorage.getJsonMap(_savedCredentialsStoredKey);
      if (map != null) {
        final credentials = SavedCredentialsDto.fromJson(map);
        if (credentials.token.isNotEmpty) {
          return credentials;
        }
      }
    } catch (e, _) {
      log("Failed to load saved credentials", error: e);
    }
    return null;
  }
}
