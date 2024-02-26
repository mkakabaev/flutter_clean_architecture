import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mk_kit/mk_kit.dart';
import 'package:rxdart/rxdart.dart';

import '../logging.dart';
import 'go_router_patch.dart';

class MyShellRoute extends ShellRoute with DescriptionProvider, LoggerObject, MyShellRoutePatch {
  MyShellRoute({
    required super.builder,
    required super.routes,
  })  : assert(builder != null),
        super(pageBuilder: (context, state, child) => MyTransitionPage(state, builder!(context, state, child)));
}

class MyRoute extends GoRoute {
  final MyRouteTransition? redirectTransition;
  MyRoute({
    required super.path,
    required super.builder,
    super.routes,
    super.redirect,
    this.redirectTransition,
  })  : assert(builder != null),
        super(pageBuilder: (context, state) => MyTransitionPage(state, builder!(context, state)));

  @override
  String get name => '$runtimeType';

  @override
  GoRouterRedirect? get redirect {
    return (super.redirect == null) ? null : _patchedRedirect;
  }

  FutureOr<String?> _patchedRedirect(BuildContext context, GoRouterState state) async {
    final location = await super.redirect?.call(context, state);
    if (location != null) {
      await router.getShellRouteAwaitingFutureForPatch(location);
    }

    if (redirectTransition != null) {
      MyTransitionPage._currentRequest = (redirectTransition, false);
    }
    return location;
  }

  ///
  /// Make this protected to endorse strong typing go*() methods in descendants
  ///
  @protected
  void performGo({
    Map<String, String> pathParameters = const <String, String>{},
    MyRouteTransition? transition,
    bool fullscreenDialog = false,
    Object? extra,
  }) {
    MyTransitionPage._currentRequest = (transition, fullscreenDialog);
    router.goNamed(name, pathParameters: pathParameters, extra: extra);
  }

  @protected
  MyGoRouter get router => MyGoRouter._instance;
}

///
/// A common way to add direct paramless go() navigation. Add this mixin to your MyRoute's descendants
///
mixin MyRouteParamlessGo on MyRoute {
  void go({MyRouteTransition? transition, bool fullscreenDialog = false}) =>
      performGo(transition: transition, fullscreenDialog: fullscreenDialog);
}

enum MyRouteTransition { defaultTransition, fade, flip }

class MyTransitionPage<T> extends Page<T> {
  static (MyRouteTransition? transition, bool fullScreenDialog)? _currentRequest;

  factory MyTransitionPage(GoRouterState state, Widget child) {
    return MyTransitionPage._(
      key: state.pageKey,
      child: child,
      transition: _currentRequest?.$1 ?? MyRouteTransition.defaultTransition,
      fullscreenDialog: _currentRequest?.$2 ?? false,
    );
  }

  const MyTransitionPage._({
    required this.child,
    required this.transition,
    required this.fullscreenDialog,
    super.key,
  });

  final Widget child;
  final MyRouteTransition transition;
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) => _MyTransitionPageRoute<T>(this);
}

///
/// mixed with MaterialRouteTransitionMixin for 1) the default transition2, 2) be supported by native Material routes
///
class _MyTransitionPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  _MyTransitionPageRoute(MyTransitionPage<T> page)
      : super(
          settings: page,
          fullscreenDialog: page.fullscreenDialog,
        );

  MyRouteTransition? _effectiveBackTransition;
  MyRouteTransition get _transition => _page.transition;
  MyTransitionPage<T> get _page => settings as MyTransitionPage<T>;

  @override
  bool get barrierDismissible => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  // @override
  // Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Widget buildContent(BuildContext context) => throw UnimplementedError('Should not be called');

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: _page.child,
      );

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // If the next route is also a custom transition, we can adjust own animation to match the next route's transition
    // This is useful for back transitions
    if (nextRoute is _MyTransitionPageRoute) {
      switch (nextRoute._transition) {
        case MyRouteTransition.flip:
        case MyRouteTransition.fade:
          _effectiveBackTransition = nextRoute._transition;
          return true;

        case MyRouteTransition.defaultTransition:
          break;
      }
      return !nextRoute.fullscreenDialog;
    }

    // Default behavior, borrowed from MaterialRouteTransitionMixin
    return super.canTransitionTo(nextRoute);
  }

  Widget _buildFadeTransition(BuildContext context, Animation<double> animation, Widget child, [isBack = false]) {
    if (isBack) {
      return FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
          child: child);
    } else {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.linear).animate(animation),
        child: child,
      );
    }
  }

  Widget _buildFlipTransition(BuildContext context, Animation<double> animation, Widget child, [isBack = false]) {
    const tilt = 0.001;
    const curve = Curves.easeOut;
    final deepness = (MediaQuery.of(context).size.width * 0.75).clamp(50.0, 400.0);

    if (isBack) {
      return MatrixTransition(
        animation: CurvedAnimation(
          parent: animation,
          curve: Interval(0.0, 0.5, curve: curve.flipped),
        ),
        child: child,
        onTransform: (double value) {
          final angle = lerpDouble(0.0, pi / 2, value) ?? 0.0;
          final translate = lerpDouble(0.0, deepness, value) ?? 0.0;
          return Matrix4.identity()
            ..setEntry(3, 2, tilt)
            ..translate(0.0, 0.0, translate)
            ..rotateY(angle);
        },
      );
    } else {
      return MatrixTransition(
        animation: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.5, 1.0, curve: curve),
        ),
        child: child,
        onTransform: (double value) {
          final angle = lerpDouble(pi / 2, 0.0, value) ?? 0.0;
          final translate = lerpDouble(-deepness, 0.0, value) ?? 0.0;
          return Matrix4.identity()
            ..setEntry(3, 2, -tilt)
            ..translate(0.0, 0.0, translate)
            ..rotateY(angle);
        },
      );
    }
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (_effectiveBackTransition) {
      case MyRouteTransition.flip:
        return _buildFlipTransition(context, secondaryAnimation, child, true);

      case MyRouteTransition.fade:
        return _buildFadeTransition(context, secondaryAnimation, child, true);

      case null:
      case MyRouteTransition.defaultTransition:
        break;
    }

    switch (_transition) {
      // return SlideTransition(
      //     position: Tween<Offset>(
      //         end: Offset(_transitionType == MyRouteTransition.slideRight ? 1 : -1, 0),
      //         begin: Offset.zero,
      //     ).animate(secondaryAnimation),
      //     child: SlideTransition(
      //         position: Tween<Offset>(
      //             begin: Offset(_transitionType == MyRouteTransition.slideRight ? -1 : 1, 0),
      //             end: Offset.zero,
      //         ).animate(animation),
      //         child: child,
      //     ),
      // );

      case MyRouteTransition.flip:
        return _buildFlipTransition(context, animation, child);

      case MyRouteTransition.fade:
        return _buildFadeTransition(context, animation, child);

      case MyRouteTransition.defaultTransition:
        return super.buildTransitions(context, animation, secondaryAnimation, child);
    }
  }
}

class MyGoRouter extends GoRouter {
  final _goSubject = PublishSubject<({String location, Object? extra, Future? waitUntil})>();

  static late final MyGoRouter _instance; // singleton

  MyGoRouter({
    required List<RouteBase> routes,
    super.initialLocation,
    super.debugLogDiagnostics,
    super.onException,
  }) : super.routingConfig(
          routingConfig: ValueNotifier(
            RoutingConfig(routes: routes, redirect: (_, __) => null, redirectLimit: 5),
          ),
        ) {
    _instance = this;
    //
    _goSubject.debounce((event) {
      final waitUntil = event.waitUntil;
      return waitUntil != null ? Stream.fromFuture(waitUntil) : const Stream.empty();
    }).listen((event) {
      super.go(event.location, extra: event.extra);
    });
  }

  @override
  void go(String location, {Object? extra}) {
    final waitUntil = getShellRouteAwaitingFutureForPatch(location, extra: extra);
    _goSubject.add((
      location: location,
      extra: extra,
      waitUntil: waitUntil,
    ));
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    MyTransitionPage._currentRequest = null;
    return super.push(location, extra: extra);
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(String location, {Object? extra}) {
    MyTransitionPage._currentRequest = null;
    return super.pushReplacement(location, extra: extra);
  }

  @override
  Future<T?> replace<T>(String location, {Object? extra}) {
    MyTransitionPage._currentRequest = null;
    return super.replace(location, extra: extra);
  }
}
