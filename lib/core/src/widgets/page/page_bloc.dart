import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mk_kit/mk_kit.dart';

import 'page_controller.dart';

abstract class PageBloc<BLOC_STATE> extends Cubit<BLOC_STATE> {
  @protected
  final disposeBag = DisposeBag();

  @protected
  final PageController1 pageController;

  PageBloc(super.initialState, this.pageController) {
    disposeBag.name = "$runtimeType";
  }

  @override
  Future<void> close() {
    disposeBag.dispose();
    return super.close();
  }
}
