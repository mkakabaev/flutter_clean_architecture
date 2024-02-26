import 'dart:developer' as developer;

enum LogLevel { all, errors, nothing }

mixin LoggerObject {
  LogLevel get logLevel => LogLevel.all;

  void log(String s, {Object? error}) {
    switch (logLevel) {
      case LogLevel.all:
        break;
      case LogLevel.errors:
        if (error == null) {
          return;
        }
        break;
      case LogLevel.nothing:
        return;
    }

    final buffer = StringBuffer();
    final t = DateTime.now();
    buffer.write('[');
    buffer.write(t.hour.toString().padLeft(2, '0'));
    buffer.write(':');
    buffer.write(t.minute.toString().padLeft(2, '0'));
    buffer.write(':');
    buffer.write(t.second.toString().padLeft(2, '0'));
    buffer.write('.');
    buffer.write(t.millisecond.toString().padLeft(3, '0'));
    buffer.write('] ');
    buffer.write(this);
    buffer.write(': ');
    buffer.write(s);
    developer.log(buffer.toString(), error: error);
  }
}
