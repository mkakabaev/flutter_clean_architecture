import 'package:mk_clean_architecture/core/core.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    super.key,
  });

  @override
  State createState() => _SignInState();
}

class _SignInState extends PageState<SignIn, SignInBloc, SignInBlocState> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  SignInBloc createBloc(PageController1 controller) => SignInBloc(controller);

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: bloc.state.username);
    _usernameController.addListener(() {
      bloc.setUsername(_usernameController.text);
    });

    _passwordController = TextEditingController(text: bloc.state.username);
    _passwordController.addListener(() {
      bloc.setPassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didBlocChange(BuildContext context, SignInBlocState blocState) {
    if (blocState.username != _usernameController.text) {
      _usernameController.text = blocState.username;
    }
    if (blocState.password != _passwordController.text) {
      _passwordController.text = blocState.password;
    }
  }

  @override
  Widget buildPage(BuildContext context, SignInBlocState blocState) {
    final isSubmitting = blocState.isSubmitting;
    return GestureDetector(
      onTap: controller.dropFocus,
      child: Scaffold(
        // backgroundColor: Colors.orange[100],
        appBar: AppBar(
          title: const Text('Sign In'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sign In section
                MyTextField(
                  controller: _usernameController,
                  role: MyTextFieldRole.username,
                  label: 'Username',
                  isRequired: true,
                  // autofocus: true,
                  validation: blocState.usernameValidation,
                ),

                MyTextField(
                  controller: _passwordController,
                  role: MyTextFieldRole.password,
                  label: 'Password',
                  isRequired: true,
                  validation: blocState.passwordValidation,
                ),

                MyButton(
                  title: "Sign In",
                  isEnabled: blocState.canSubmit,
                  showProgress: isSubmitting,
                  onTap: bloc.signIn,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                ),

                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    MyButton.secondary(
                      title: "Sign Up",
                      onTap: bloc.signUp,
                      margin: const EdgeInsets.only(left: 4),
                    ),
                  ],
                ),

                // Hint
                _buildHint(blocState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHint(SignInBlocState blocState) {
    final hint = blocState.hint;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: blocState.showHint ? 1 : 0,
      child: Column(
        children: [
          const Divider(height: 40, endIndent: 20, indent: 20),
          const Text(
            // ignore: prefer_adjacent_string_concatenation
            'dummyjson.com mocking site returns randomly generated data. ' +
                'To be able to sign in you can try the following credentials: \n',
            textAlign: TextAlign.center,
          ),
          for (final r in [('Username', hint?.username), ('Password', hint?.password)])
            Text(
              '${r.$1}: ${r.$2}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          MyButton.secondary(
            title: 'Insert',
            isEnabled: !blocState.isSubmitting,
            onTap: bloc.applyCredentialsHint,
          ),
        ],
      ),
    );
  }
}
