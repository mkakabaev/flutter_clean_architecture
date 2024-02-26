import 'package:mk_clean_architecture/core/core.dart';

@injectable
class ValidateUsernameUseCase {
  InputValidation call(String username) {
    if (username.isEmpty) {
      return const InputValidation.empty();
    }
    if (username.replaceFirst(RegExp(r'[^A-Z0-9a-z_.]'), '').length != username.length) {
      return InputValidation.invalid(MyError(
          'Username may contain only letters, numbers, underscores, and periods. No spaces or special characters are allowed.'));
    }
    if (username.length < 3) {
      return InputValidation.invalid(MyError('Username must be at least 3 characters long'));
    }
    return const InputValidation.valid();
  }
}
