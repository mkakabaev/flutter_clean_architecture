import 'package:mk_kit/mk_kit.dart';

sealed class AuthSession with DescriptionProvider {
  const AuthSession();

  const factory AuthSession.initial() = AuthSessionInitial;
  const factory AuthSession.signedOut() = AuthSessionSignedOut;
  const factory AuthSession.signedIn() = AuthSessionSignedIn;

  bool get isSignedIn => false;
}

class AuthSessionInitial extends AuthSession {
  const AuthSessionInitial();
}

class AuthSessionSignedOut extends AuthSession {
  const AuthSessionSignedOut();
}

class AuthSessionSignedIn extends AuthSession {
  const AuthSessionSignedIn();

  @override
  bool get isSignedIn => true;
}
