import 'package:equatable/equatable.dart';

class SignInRequest extends Equatable {
  final String username;
  final String password;

  const SignInRequest({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
