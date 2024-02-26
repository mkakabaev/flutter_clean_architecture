import 'package:mk_clean_architecture/router.dart';
import 'package:equatable/equatable.dart';
import 'package:mk_clean_architecture/core/core.dart';

class SignUpPageBlocState extends Equatable {
  const SignUpPageBlocState();

  @override
  List<Object?> get props => [];
}

class SignUpPageBloc extends PageBloc<SignUpPageBlocState> {
  factory SignUpPageBloc(PageController1 pageController) {
    return SignUpPageBloc._(const SignUpPageBlocState(), pageController);
  }

  SignUpPageBloc._(super.initialState, super.pageController);

  void completeWithSuccess([MyRouteTransition transition = MyRouteTransition.fade]) async {
    // await getIt<LoginUseCase>()();
    // getIt<HomeRoute>().go(transition: transition);
  }

  void goToSignIn() {
    getIt<SignInRoute>().go();
  }
}
