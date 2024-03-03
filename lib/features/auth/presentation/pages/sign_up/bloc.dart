import 'package:equatable/equatable.dart';

import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/router.dart';

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

  void goToSignIn() {
    getIt<SignInRoute>().go();
  }
}
