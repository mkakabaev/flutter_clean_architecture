import 'dart:async';

extension MyStreamExtensions<T> on Stream<T> {
  Future<S> firstOfType<S extends T>() => expand<S>((s) => s is S ? [s] : []).first;
  Future<T> firstOfNonType<S extends T>() => expand<T>((s) => s is S ? [] : [s]).first;
}

// extension MyBehaviorSubjectExtensions<T> on BehaviorSubject<T> {
//   void addUnique(T event) {
//     if (event != value) {
//       add(event);
//     }
//   }
// }
