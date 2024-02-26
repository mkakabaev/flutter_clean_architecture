import 'package:mk_clean_architecture/core/core.dart';

@injectable
class ValidatePasswordUseCase {
  InputValidation call(String password, {required bool forSignUp}) {
    if (password.isEmpty) {
      return const InputValidation.empty();
    }
    if (forSignUp) {
      if (password.replaceFirst(RegExp(r'[^A-Z0-9a-z_.]'), '').length != password.length) {
        return InputValidation.invalid(MyError(
            'Password may contain only letters, numbers, underscores, and periods. No spaces or special characters are allowed.'));
      }
      if (password.length < 6) {
        return InputValidation.invalid(MyError('Password must be at least 6 characters long'));
      }
    }
    return const InputValidation.valid();
  }
}
