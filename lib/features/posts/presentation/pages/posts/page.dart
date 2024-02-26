import 'package:mk_clean_architecture/core/core.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/posts.dart';
import 'bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({
    super.key,
  });

  @override
  State createState() => _PostsPageState();
}

class _PostsPageState extends PageState<PostsPage, PostsPageBloc, PostsPageBlocState> {
  @override
  PostsPageBloc createBloc(PageController1 controller) => PostsPageBloc(controller);

  @override
  Widget buildPage(BuildContext context, PostsPageBlocState blocState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: _buildBody(context, blocState),
    );
  }

  Widget _buildBody(BuildContext context, PostsPageBlocState blocState) {
    final ValueState(value: posts, error: error) = blocState.myPosts;

    if (posts != null) {
      return _buildPosts(context, posts);
    }

    if (error != null) {
      return MyErrorWidget(
        error: error,
        onRetry: bloc.reloadMyPosts,
      );
    }

    return const MyLoadingWidget();
  }

  Widget _buildPosts(BuildContext context, Posts posts) {
    return RefreshIndicator(
      strokeWidth: 4.0,
      onRefresh: bloc.reloadMyPosts,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList.separated(
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              if (index >= posts.posts.length) {
                return null;
              }
              final post = posts.posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            },
          ),
        ],
      ),
    );
  }
}
