import 'package:mk_clean_architecture/core/core.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/posts.dart';
import '../../../domain/use_cases/get_my_posts.dart';
import '../../../domain/use_cases/reload_my_posts.dart';

class PostsPageBlocState extends Equatable {
  final ValueState<Posts> myPosts;
  const PostsPageBlocState({
    required this.myPosts,
  });

  PostsPageBlocState copyWith({
    ValueState<Posts>? myPosts,
  }) {
    return PostsPageBlocState(
      myPosts: myPosts ?? this.myPosts,
    );
  }

  @override
  List<Object> get props => [myPosts];
}

class PostsPageBloc extends PageBloc<PostsPageBlocState> {
  factory PostsPageBloc(PageController1 pageController) {
    final initialState = PostsPageBlocState(myPosts: ValueState.empty());
    return PostsPageBloc._(initialState, pageController);
  }

  PostsPageBloc._(super.initialState, super.pageController) {
    final myPostsStream = getIt<GetMyPostsUseCase>()();

    // Initiate data refreshing on page opening - if we have no data or broken data
    final posts = myPostsStream.value;
    if (posts.isEmpty || posts.error != null) {
      Future(() => reloadMyPosts()); // We need to wait for the page to be fully opened (initState is called)
    }

    disposeBag.subscriptions <<
        myPostsStream.listen((value) {
          // In case we receive an error AFTER successful value fetching then we still will show
          // existing data but also will show an error popup.
          if (value case ValueStateLoadFailed(error: final error, value: final posts) when posts != null) {
            pageController.showError(error);
          }

          emit(state.copyWith(myPosts: value));
        });
  }

  Future<void> reloadMyPosts() async {
    pageController.hideErrors();
    await getIt<ReloadMyPostsUseCase>()();
  }
}
