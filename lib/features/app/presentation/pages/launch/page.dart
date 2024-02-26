import 'package:flutter/material.dart';
import 'package:mk_clean_architecture/core/core.dart';
import 'bloc.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({
    super.key,
  });

  @override
  State createState() => _LaunchPageState();
}

class _LaunchPageState extends PageState<LaunchPage, LaunchPageBloc, LaunchPageBlocState> {
  @override
  LaunchPageBloc createBloc(PageController1 controller) => LaunchPageBloc(controller);

  @override
  Widget buildPage(BuildContext context, LaunchPageBlocState blocState) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
