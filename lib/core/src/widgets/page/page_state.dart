import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mk_kit/mk_kit.dart';

import 'page_bloc.dart';
import 'page_controller.dart';

abstract class PageState<T extends StatefulWidget, BLOC extends PageBloc<BLOC_STATE>, BLOC_STATE> extends State<T> {
  @protected
  late final PageController1 controller;

  @protected
  final disposeBag = DisposeBag();

  @protected
  late final BLOC bloc;

  @override
  void initState() {
    super.initState();

    controller = PageController1(buildContext: context);

    disposeBag.name = "$runtimeType";
    disposeBag.closables << (bloc = createBloc(controller));
  }

  @override
  void dispose() {
    disposeBag.dispose();
    super.dispose();
  }

  @protected
  BLOC createBloc(PageController1 controller);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BLOC, BLOC_STATE>(bloc: bloc, listener: didBlocChange, builder: buildPage);
  }

  @protected
  void didBlocChange(BuildContext context, BLOC_STATE blocState) {
    // nothing in the base
  }

  @protected
  Widget buildPage(BuildContext context, BLOC_STATE blocState);
}
