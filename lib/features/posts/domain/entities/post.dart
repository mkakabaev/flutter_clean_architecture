import 'package:mk_clean_architecture/features/users/users.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final UserId userId;
  final String body;
  final List<String> tags;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.tags,
  });

  @override
  List<Object?> get props => [id, userId, title, body, tags];
}
