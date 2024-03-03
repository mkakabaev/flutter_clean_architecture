import 'package:equatable/equatable.dart';

import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/auth/auth.dart';
import 'package:mk_clean_architecture/router.dart';

class HomePageBlocState extends Equatable {
  const HomePageBlocState();

  @override
  List<Object> get props => [];
}

class HomePageBloc extends PageBloc<HomePageBlocState> {
  factory HomePageBloc(PageController1 pageController) {
    return HomePageBloc._(const HomePageBlocState(), pageController);
  }

  HomePageBloc._(super.initialState, super.pageController) {
    // Subscribe to the AuthSession. This will be used to determine if we can can continue to the home page
    // or if we need to redirect the user to the sign_in page. Note that this happened after the initial
    // page routing (i.e. after LaunchPage is displayed and AppBootstrapState is ready to display the UI)
    disposeBag.subscriptions <<
        getIt<GetAuthSessionUseCase>()().listen((state) {
          if (!state.isSignedIn) {
            getIt<SignInRoute>().go(fullscreenDialog: true);
          }
        });
  }
}
