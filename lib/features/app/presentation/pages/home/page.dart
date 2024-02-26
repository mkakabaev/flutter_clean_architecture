import 'dart:math';

import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './bloc.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({
    super.key,
    required this.child,
  });

  @override
  State createState() => _HomePageState();
}

class _Tab {
  final String label;
  final IconData icon;
  final MyRouteParamlessGo route;

  const _Tab({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class _HomePageState extends PageState<HomePage, HomePageBloc, HomePageBlocState> with LoggerObject {
  final tabs = [
    _Tab(label: "Posts", icon: Icons.edit_document, route: getIt<PostsRoute>()),
    _Tab(label: "User Profile", icon: Icons.person, route: getIt<UserProfileRoute>()),
  ];

  @override
  HomePageBloc createBloc(PageController1 controller) => HomePageBloc(controller);

  @override
  Widget buildPage(BuildContext context, HomePageBlocState blocState) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: tabs
            .map((tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ))
            .toList(),
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return max(tabs.indexWhere((tab) => location.startsWith(tab.route.path)), 0);
  }

  void _onItemTapped(int index, BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    if (currentIndex != index) {
      final route = tabs.elementAtOrNull(index)?.route;
      assert(route != null);
      route?.go(transition: MyRouteTransition.fade);
    }
  }
}
