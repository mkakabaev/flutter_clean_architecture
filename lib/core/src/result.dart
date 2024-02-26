import 'package:async/async.dart';

import 'error.dart';

typedef FutureResult<T> = Future<Result<T>>;

extension MyResultExtension<T> on Result<T> {
  ///
  /// Easy way to return the error casted to MyError unconditionally. This reduces amount of code needed to handle errors.
  ///
  MyError get requiredError {
    final error = asError?.error;
    if (error == null) {
      throw MyError('Result is not an error. Check isError before calling requiredError');
    }
    if (error is MyError) {
      return error;
    }
    return MyError("$error");
  }

  ///
  /// Easy way to return the value unconditionally. This reduces amount of code needed to handle values.
  ///
  T get requiredValue {
    final valueResult = asValue;
    if (valueResult == null) {
      throw MyError('Result is not a value. Check isValue before calling requiredValue');
    }
    return valueResult.value;
  }

  /// Add toString() capability without having to extend it
  String myToString() {
    if (isValue) {
      return '<ResultValue ${asValue!.value}>';
    }
    return '<ErrorValue: ${asError!.error}>';
  }

  ///
  /// In many situations we need not the concrete result value but a signal that the value was obtained successfully.
  /// Se this is a way to achieve it
  ///
  Result<void> get asVoid {
    if (isValue) {
      return Result.value(null);
    }
    return asError!;
  }

  Result<R> mapError<R>() {
    return Result.error(requiredError);
  }

  Result<R> map<R>(R Function(T value) mapper) {
    try {
      if (isValue) {
        return Result.value(mapper(asValue!.value));
      }
    } catch (e) {
      return Result.error(MyError('Error mapping result $T to $R: $e'));
    }
    return asError!;
  }
}
