enum MyErrorType {
  other,
  unauthorized,
  tokenExpired,
}

class MyError extends Error {
  final String message;
  final MyErrorType type;

  MyError(this.message, {this.type = MyErrorType.other});
  MyError.unauthorized(this.message) : type = MyErrorType.unauthorized;

  factory MyError.from(Object e) {
    if (e is MyError) {
      return e;
    }
    return MyError('$e');
  }

  @override
  String toString() {
    return message;
  }
}
