import 'package:equatable/equatable.dart';

class CredentialsHint extends Equatable {
  final String username;
  final String password;

  const CredentialsHint({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
