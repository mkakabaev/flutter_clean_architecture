import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mk_clean_architecture/core/core.dart';

import 'bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State createState() => _SignUpPageState();
}

class _SignUpPageState extends PageState<SignUpPage, SignUpPageBloc, SignUpPageBlocState> {
  @override
  SignUpPageBloc createBloc(PageController1 controller) => SignUpPageBloc(controller);

  @override
  Widget buildPage(BuildContext context, SignUpPageBlocState blocState) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1),
            Text(
              'Under construction',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            MyButton(
              title: "Back to Sign In",
              onTap: bloc.goToSignIn,
            ),
            MyButton(
              title: "PUSH to wrong route",
              onTap: () {
                GoRouter.of(context).push('/some/nonexistent/route');
              },
            ),
            const Spacer(flex: 2)
          ],
        ),
      ),
    );
  }
}
