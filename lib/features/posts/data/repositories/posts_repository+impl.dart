import 'dart:async';

import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/users/users.dart';
import 'package:mk_clean_architecture/services/api_client/api_client.dart';
import 'package:mk_kit/mk_kit.dart';

import '../../domain/entities/posts.dart';
import '../../domain/repositories/posts_repository.dart';

@LazySingleton(as: PostsRepository)
class PostsRepositoryImpl with LoggerObject implements PostsRepository {
  final _disposeBag = DisposeBag();
  final ApiClient _apiClient;
  var _userIdCompleter = Completer<UserId>();
  UserId? myUserId;
  late final ValueStateHost<Posts> _myPostsHost;

  PostsRepositoryImpl(this._apiClient) {
    _myPostsHost = ValueStateHost(_loadMyPosts);

    // We actually need only valid user id as a signal that session is opened and we can load own posts.
    // So here we subscribe to the user session and wait for the user id to be available. <null> means no session.
    _disposeBag.subscriptions <<
        getIt<GetMyUserUseCase>()().map((s) => s.value?.id).listen((userId) {
          // multiple events can be fired, but we need only the difference
          if (myUserId == userId) {
            return;
          }
          if (userId == null) {
            // Some ID => null transformations, i.e. session was ended. Reset the data and start a new session
            if (_userIdCompleter.isCompleted) {
              _myPostsHost.reset();
              _userIdCompleter = Completer<UserId>();
            } else {
              assert(false, "UserId(null => null) transformation, should not be possible");
            }
          } else {
            if (_userIdCompleter.isCompleted) {
              // switching from one existing user id to another.
              // Should never happen in real life but just in case start a new session (marked as completed)
              _userIdCompleter = Completer<UserId>();
              _myPostsHost.reset(); // reset the data
              Future(() => _myPostsHost.reload()); // schedule reloading
            }
            _userIdCompleter.complete(userId);
          }
          myUserId = userId;
        });
  }

  @override
  ValueStream<ValueState<Posts>> get myPosts => _myPostsHost.valueStream;

  @override
  Future<ValueState<Posts>> reloadMyPosts() => _myPostsHost.reload();

  FutureResult<Posts> _loadMyPosts() async {
    try {
      final userId = await _userIdCompleter.future;
      final posts = await _apiClient.getPostsForUser(userId: userId);
      return posts.map((r) => r.toPosts());
    } catch (e, s) {
      return FutureResult.error(e, s);
    }
  }
}
