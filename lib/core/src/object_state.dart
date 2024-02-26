import 'dart:async';

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:mk_kit/mk_kit.dart';
import 'package:rxdart/rxdart.dart';

import 'error.dart';
import 'result.dart';

sealed class ValueState<T extends Object> extends Equatable with DescriptionProvider {
  const ValueState();

  // Note: no const constructor here because it lost the type (T => Never)
  factory ValueState.empty() => ValueStateEmpty(); // ignore: prefer_const_constructors

  factory ValueState.loading(T? value) = ValueStateLoading;
  factory ValueState.loaded(T value) = ValueStateLoaded;
  factory ValueState.loadFailed(MyError error, T? value) = ValueStateLoadFailed;

  MyError? get error => null;
  T? get value => null;
  bool get isEmpty => false;
  bool get isLoading => false;

  @override
  List<Object?> get props => [value, error];

  ValueState<T> startLoading() => ValueState<T>.loading(value);
  ValueState<T> endLoading(Result<T> result) => result.isError
      ? ValueState<T>.loadFailed(result.requiredError, value)
      : ValueState<T>.loaded(result.requiredValue);
}

class ValueStateEmpty<T extends Object> extends ValueState<T> {
  const ValueStateEmpty();

  @override
  void configureDescription(DescriptionBuilder db) {}

  @override
  bool get isEmpty => true;
}

class ValueStateLoading<T extends Object> extends ValueState<T> {
  @override
  final T? value;

  const ValueStateLoading(this.value);

  @override
  bool get isLoading => true;

  @override
  void configureDescription(DescriptionBuilder db) {
    db.addValue(value);
  }
}

class ValueStateLoaded<T extends Object> extends ValueState<T> {
  @override
  final T value;

  const ValueStateLoaded(this.value);

  @override
  void configureDescription(DescriptionBuilder db) {
    db.addValue(value);
  }
}

class ValueStateLoadFailed<T extends Object> extends ValueState<T> {
  @override
  final T? value;

  @override
  final MyError error;

  const ValueStateLoadFailed(this.error, this.value);

  @override
  void configureDescription(DescriptionBuilder db) {
    db.addValue(value);
    db.add('error', error);
  }
}

class ValueStateHost<T extends Object> {
  Completer<ValueState<T>>? _reloadCompleter;
  late final BehaviorSubject<ValueState<T>> _subject;
  final FutureResult<T> Function() loader;

  ValueStateHost(this.loader) {
    _subject = BehaviorSubject<ValueState<T>>.seeded(ValueState.empty(), onListen: () {
      // on the first listener, we start loading if needed
      if (_subject.value.isEmpty) {
        reload();
      }
    });
  }

  ValueStream<ValueState<T>> get valueStream => _subject;

  void reset() {
    _subject.value = ValueState<T>.empty();
  }

  void updateLoaded(T newValue) {
    _subject.value = ValueState<T>.loaded(newValue);
  }

  Future<ValueState<T>> reload() {
    // Return immediately in the case of a reload already in progress
    final existingCompleter = _reloadCompleter;
    if (existingCompleter != null) {
      assert(_subject.value is ValueStateLoading);
      return existingCompleter.future;
    }

    // Start new updating
    final completer = _reloadCompleter = Completer<ValueState<T>>();
    _subject.value = _subject.value.startLoading();
    loader().then((r) {
      _subject.value = _subject.value.endLoading(r);
      completer.complete(_subject.value);
      _reloadCompleter = null;
    });

    return completer.future;
  }
}
