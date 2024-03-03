import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/router.dart';

import '../../../domain/entities/app_bootstrap_state.dart';
import '../../../domain/use_cases/get_app_bootstrap_state.dart';

class LaunchPageBlocState extends Equatable {
  const LaunchPageBlocState();

  @override
  List<Object> get props => [];
}

class LaunchPageBloc extends PageBloc<LaunchPageBlocState> {
  factory LaunchPageBloc(PageController1 pageController) {
    return LaunchPageBloc._(const LaunchPageBlocState(), pageController);
  }

  LaunchPageBloc._(super.initialState, super.pageController) {
    _waitUntilAppIsReadyThenOpenUI();
  }

  /// We need only the the very first AppBootstrapStateReady() state.
  /// In any case we will wait at least 2 seconds - just to get chances to show a spinner
  void _waitUntilAppIsReadyThenOpenUI() async {
    final readyStateFuture = getIt<GetAppBootstrapStateUseCase>()().firstOfType<AppBootstrapStateReady>();
    final waitAtLeastFuture = Future.delayed(const Duration(seconds: 2));
    final readyState = (await (readyStateFuture, waitAtLeastFuture).wait).$1;

    if (readyState.authenticated) {
      getIt<HomeRoute>().go();
    } else {
      getIt<SignInRoute>().go(fullscreenDialog: true);
    }
  }
}
