import 'package:mk_clean_architecture/router.dart';
import 'package:equatable/equatable.dart';
import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_kit/mk_kit.dart';

import '../../../domain/entities/credentials_hint.dart';
import '../../../domain/entities/sign_in_request.dart';
import '../../../domain/use_cases/get_credentials_hint.dart';
import '../../../domain/use_cases/sign_in_use_case.dart';
import '../../../domain/use_cases/validate_password.dart';
import '../../../domain/use_cases/validate_username.dart';

class SignInBlocState extends Equatable {
  final String username;
  final String password;
  final bool isSubmitting;
  final CredentialsHint? hint;

  const SignInBlocState({
    required this.username,
    required this.password,
    required this.isSubmitting,
    required this.hint,
  });

  SignInBlocState copyWith({
    String? username,
    String? password,
    bool? isSubmitting,
    CWValue<CredentialsHint>? hint,
  }) {
    return SignInBlocState(
        username: username ?? this.username,
        password: password ?? this.password,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        hint: CWValue.resolve(hint, this.hint));
  }

  @override
  List<Object?> get props => [username, password, isSubmitting, hint];

  bool get canSubmit => passwordValidation.isValid && usernameValidation.isValid && !isSubmitting;
  bool get showHint => hint != null && (username != hint?.username || password != hint?.password);

  // This is not too complicated processing so let it be a computed value. if it comes more complex
  // then the validation should be cached in a field and calculated in the copyWith and the constructor method.
  InputValidation get usernameValidation => getIt<ValidateUsernameUseCase>()(username);

  // Same notes as for usernameValidation
  InputValidation get passwordValidation => getIt<ValidatePasswordUseCase>()(password, forSignUp: false);
}

class SignInBloc extends PageBloc<SignInBlocState> {
  factory SignInBloc(PageController1 pageController) {
    const initialState = SignInBlocState(
      username: '',
      password: '',
      isSubmitting: false,
      hint: null,
    );
    return SignInBloc._(initialState, pageController);
  }

  SignInBloc._(super.initialState, super.pageController) {
    _fetchCredentialsHint();
  }

  // At the very beginning we will ask for user credentials hint. This is pure dummyjson.com specific stuff,
  // because it generates random data. Is not a real use case. Should be removed as soon as the template
  // is cloned and become a real production app.
  void _fetchCredentialsHint() async {
    final result = await getIt<GetCredentialsHintUseCase>()();
    if (isClosed) {
      return;
    }
    if (result.isError) {
      pageController.showError(MyError("Unable to get credentials hint: ${result.requiredError}"));
      return;
    }
    final hint = result.requiredValue;
    if (hint == null) {
      pageController.showError(MyError("No credentials hint available"));
      return;
    }
    emit(state.copyWith(hint: CWValue(hint)));
  }

  void applyCredentialsHint() {
    pageController.dropFocus(); // ? move to page ?
    pageController.hideErrors();

    final hint = state.hint;
    if (hint == null) {
      assert(false);
      return;
    }
    emit(state.copyWith(
      username: hint.username,
      password: hint.password,
    ));
  }

  void setUsername(String value) {
    emit(state.copyWith(username: value.trim()));
  }

  void setPassword(String value) {
    emit(state.copyWith(password: value.trim()));
  }

  void signIn() async {
    if (!state.canSubmit) {
      assert(false);
      return;
    }

    // perform sign_in
    pageController.dropFocus(); // ? move to page ?
    pageController.hideErrors();
    emit(state.copyWith(isSubmitting: true));
    final request = SignInRequest(username: state.username, password: state.password);
    final result = await getIt<SignInUseCase>()(request);

    // Finalize the procedure. The user might have closed this dialog before the result was returned
    // Also, we don't want to proceed if the user has already switched to a child page (Sign Up, for instance)
    if (isClosed) {
      return;
    }
    emit(state.copyWith(isSubmitting: false));
    if (!pageController.isTopmost) {
      return;
    }

    // handle error
    if (result.isError) {
      pageController.showError(result.requiredError);
      return;
    }

    // Handle successful sign_in. Proceed to the the home page
    getIt<HomeRoute>().go();
  }

  void signUp() {
    pageController.dropFocus(); // ? move to page ?
    pageController.hideErrors();
    emit(state.copyWith(password: '', username: '')); // clean the data entered for security reasons

    getIt<SignUpRoute>().go();
  }
}
