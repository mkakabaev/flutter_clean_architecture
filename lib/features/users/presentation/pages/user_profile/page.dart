import 'package:mk_clean_architecture/core/core.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';
import 'bloc.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
  });

  @override
  State createState() => _UserProfilePageState();
}

class _UserProfilePageState extends PageState<UserProfilePage, UserProfilePageBloc, UserProfilePageBlocState> {
  @override
  UserProfilePageBloc createBloc(PageController1 controller) => UserProfilePageBloc(controller);

  @override
  Widget buildPage(BuildContext context, UserProfilePageBlocState blocState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: _buildBody(context, blocState),
        ),
        MyButton(
          title: "Sign Out",
          onTap: bloc.signOut,
          margin: const EdgeInsets.all(20),
        ),
      ]),
    );
  }

  Widget _buildBody(BuildContext context, UserProfilePageBlocState blocState) {
    final ValueState(value: user, error: error, isLoading: isLoading) = blocState.user;

    if (user != null) {
      return _buildUser(context, user, isLoading);
    }

    if (error != null) {
      return MyErrorWidget(
        error: error,
        onRetry: bloc.reloadUser,
      );
    }

    return const MyLoadingWidget();
  }

  Widget _buildUser(BuildContext context, User user, bool isLoading) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      strokeWidth: 4.0,
      onRefresh: bloc.reloadUser,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Column(
              children: [
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(user.imageUrl ?? ''),
                  ),
                ),
                Text(user.fullName, style: theme.textTheme.headlineMedium),
                const Spacer(flex: 6),
                Text(
                  isLoading ? 'Refreshing...' : 'Swipe to refresh the data',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
