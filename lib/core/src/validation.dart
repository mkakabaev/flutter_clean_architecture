import 'error.dart';

sealed class InputValidation {
  const InputValidation();
  const factory InputValidation.empty() = InputValidationEmpty;
  const factory InputValidation.valid() = InputValidationValid;
  const factory InputValidation.invalid(MyError error) = InputValidationInvalid;

  bool get isValid => false;
  bool get isEmpty => false;
}

class InputValidationEmpty extends InputValidation {
  const InputValidationEmpty();

  @override
  bool get isEmpty => true;
}

class InputValidationValid extends InputValidation {
  const InputValidationValid();

  @override
  bool get isValid => true;
}

class InputValidationInvalid extends InputValidation {
  final MyError error;
  const InputValidationInvalid(this.error);
}
