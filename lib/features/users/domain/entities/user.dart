import 'package:equatable/equatable.dart';

import 'user_id.dart';

class User extends Equatable {
  final String firstName;
  final String lastName;
  final String? imageUrl;
  final String username;
  final UserId id;

  const User({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.id,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [username, firstName, lastName, imageUrl];

  String get fullName => '$firstName $lastName'.trim();
}
