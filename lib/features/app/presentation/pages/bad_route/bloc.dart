import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/router.dart';
import 'package:equatable/equatable.dart';

class BadRoutePageBlocState extends Equatable {
  const BadRoutePageBlocState();

  @override
  List<Object> get props => [];
}

class BadRoutePageBloc extends PageBloc<BadRoutePageBlocState> {
  factory BadRoutePageBloc(PageController1 pageController) {
    return BadRoutePageBloc._(const BadRoutePageBlocState(), pageController);
  }

  BadRoutePageBloc._(super.initialState, super.pageController);

  void goHome() {
    getIt<HomeRoute>().go();
  }
}
