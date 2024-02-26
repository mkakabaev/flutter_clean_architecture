import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_utils.dart';

///
/// This file serves as a patch for a known issue with the go_router package.
/// The issue occurs when a new ShellRoute instance is opened while an old one has not been removed from the tree structure,
/// possibly due to an uncompleted dismissal animation. The typical error message associated with this issue is:
///
/// > Multiple widgets used the same GlobalKey. The key [GlobalObjectKey XXX] was used by multiple widgets.
/// > The parents of those widgets were...
///
/// The idea is to ensure that the old ShellRoute instance is removed from the tree structure before the new one is added.
/// To ensure that we wrap root ShellRoute container widget with [_Tracker] that will use
/// a helper [_Semaphore] to track the container's state in the element tree.
///

extension MyGoRouterPatch on MyGoRouter {
  ///
  /// This method is used to get a future that will complete when all shell routes
  /// that we are going to leave are unlocked (removed from the element tree)
  ///
  Future? getShellRouteAwaitingFutureForPatch(String location, {Object? extra}) {
    final currentMatches = routerDelegate.currentConfiguration.matches;
    // Get a list of semaphores for all shell routes that we are going to leave
    final destinationMatch = configuration.findMatch(location, extra: extra);
    final futures = destinationMatch.routes
        .whereType<MyShellRoute>()
        .where((shellRoute) => !currentMatches.any((match) => match.route == shellRoute))
        .map((shellRoute) => shellRoute.semaphore.future);

    return futures.isEmpty ? null : Future.wait(futures);
  }
}

mixin MyShellRoutePatch on ShellRoute {
  final semaphore = _Semaphore();

  @override
  ShellRoutePageBuilder? get pageBuilder => (context, state, child) {
        return super.pageBuilder!(
          context,
          state,
          _Tracker(semaphore: semaphore, child: child),
        );
      };
}

class _Semaphore {
  var _completer = Completer()..complete();
  var _lockCounter = 0;

  /// Lock the semaphore. This happens as soon as the first ShellRoute's container is added to the element tree
  void _lock() {
    assert(_lockCounter >= 0);
    if (_lockCounter == 0) {
      _completer = Completer();
    }
    _lockCounter++;
  }

  /// Unlock the semaphore. This happens as soon as the last ShellRoute's container is removed from the element tree
  void _unlock() {
    if (_lockCounter <= 0) {
      assert(false);
      return;
    }
    if (--_lockCounter == 0) {
      _completer.complete();
    }
  }

  /// Get a future that will complete when the all ShellRoute's containers are removed from the element tree
  Future get future => _completer.future;
}

///
/// The only purpose of the [_Tracker] widget is to report its presence in the element tree to the _Semaphore.
///
class _Tracker extends StatefulWidget {
  final Widget child;
  final _Semaphore semaphore;

  const _Tracker({
    required this.child,
    required this.semaphore,
  });

  @override
  State createState() => _TrackerState();
}

class _TrackerState extends State<_Tracker> {
  @override
  void initState() {
    super.initState();
    widget.semaphore._lock();
  }

  @override
  void dispose() {
    widget.semaphore._unlock();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
