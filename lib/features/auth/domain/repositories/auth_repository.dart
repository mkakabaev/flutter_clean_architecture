import 'package:mk_clean_architecture/core/core.dart';

import '../entities/auth_session.dart';
import '../entities/credentials_hint.dart';
import '../entities/sign_in_request.dart';

abstract interface class AuthRepository {
  Stream<AuthSession> get authSession;

  Future<void> signOut();
  FutureResult<void> signIn(SignInRequest request);
  FutureResult<CredentialsHint?> getCredentialsHint();
}
