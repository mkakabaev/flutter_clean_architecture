import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/app/app.dart';
import 'package:mk_clean_architecture/features/auth/auth.dart';
import 'package:mk_clean_architecture/features/posts/posts.dart';
import 'package:mk_clean_architecture/features/users/users.dart';

@lazySingleton
class PostsRoute extends MyRoute with MyRouteParamlessGo {
  PostsRoute()
      : super(
          path: '/posts',
          builder: (_, __) => const PostsPage(),
        );
}

@lazySingleton
class UserProfileRoute extends MyRoute with MyRouteParamlessGo {
  UserProfileRoute() : super(path: '/user-profile', builder: (_, __) => const UserProfilePage());
}

@lazySingleton
class LaunchRoute extends MyRoute {
  LaunchRoute() : super(path: "/launch", builder: (_, __) => const LaunchPage());
}

@lazySingleton
class BadRoutePageRoute extends MyRoute {
  BadRoutePageRoute() : super(path: "/404", builder: (_, state) => BadRoutePage(uri: state.extra as Uri));

  void go({required Uri uri}) => performGo(extra: uri);
}

@lazySingleton
class SignInRoute extends MyRoute with MyRouteParamlessGo {
  SignInRoute()
      : super(
          path: "/sign-in",
          builder: (_, __) => const SignIn(),
          routes: [
            getIt<SignUpRoute>(),
          ],
        );
}

@lazySingleton
class SignUpRoute extends MyRoute with MyRouteParamlessGo {
  SignUpRoute()
      : super(path: "sign-up", builder: (_, __) => const SignUpPage());
}

@lazySingleton
class HomeRoute extends MyRoute {
  HomeRoute()
      : super(
          path: "/",
          builder: (_, __) => throw UnimplementedError('Must not be called'),
          redirect: (context, state) => getIt<PostsRoute>().path, // Redirect to the first tab
          redirectTransition: MyRouteTransition.flip,
        );

  // As this is a redirect route, it does not make sense to set up transition params here
  // If you need to set up transition params then perform the go() from the concrete tab route
  void go(/*{MyRouteTransition? transition, bool fullscreenDialog = false} */) {
    // performGo();

    // Upd: To avoid redirection flickering let's go to the first tab immediately
    getIt<PostsRoute>().go(transition: MyRouteTransition.flip);
  }
}

final router = MyGoRouter(
  onException: (_, state, router) {
    getIt<BadRoutePageRoute>().go(uri: state.uri);
  },
  debugLogDiagnostics: true,
  initialLocation: getIt<LaunchRoute>().path,
  routes: [
    getIt<LaunchRoute>(),
    getIt<SignInRoute>(),
    getIt<HomeRoute>(),
    getIt<BadRoutePageRoute>(),
    MyShellRoute(
      builder: (_, __, child) => HomePage(child: child),
      routes: [
        getIt<PostsRoute>(),
        getIt<UserProfileRoute>(),
      ],
    ),
  ],
);
