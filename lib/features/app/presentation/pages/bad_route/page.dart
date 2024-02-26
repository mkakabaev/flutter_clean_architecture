import 'package:flutter/material.dart';
import 'package:mk_clean_architecture/core/core.dart';
import 'bloc.dart';

class BadRoutePage extends StatefulWidget {
  final Uri uri;

  const BadRoutePage({
    required this.uri,
    super.key,
  });

  @override
  State createState() => _BadRoutePageState();
}

class _BadRoutePageState extends PageState<BadRoutePage, BadRoutePageBloc, BadRoutePageBlocState> {
  @override
  BadRoutePageBloc createBloc(PageController1 controller) => BadRoutePageBloc(controller);

  @override
  Widget buildPage(BuildContext context, BadRoutePageBlocState blocState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oops!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Unable to open ${widget.uri}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            MyButton(
              title: "Go home",
              onTap: bloc.goHome,
            ),
          ],
        ),
      ),
    );
  }
}
