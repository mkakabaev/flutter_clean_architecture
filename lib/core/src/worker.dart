import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/foundation.dart';

///
/// A class that performs data processing in a background isolate.
/// Inspired by the example from the Dart documentation. https://dart.dev/language/isolates
/// The difference that the handler is not static but passed among with the object/message.
///
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;
  int _maxActiveRequests = 0;

  Future<R> process<M, R>(ComputeCallback<M, R> computeCallback, M message) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _maxActiveRequests = max(_maxActiveRequests, _activeRequests.length);
    _commands.send((id, message, computeCallback));
    return await completer.future;
  }

  // A little bit od statistics. Should be some time measurements added later.
  int get activeRequests => _activeRequests.length;
  int get maxActiveRequests => _maxActiveRequests;

  static Future<Worker> spawn({required String name}) async {
    // Create a receive port and add its initial message handler
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    final initPort = RawReceivePort();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    // Spawn the isolate
    try {
      await Isolate.spawn(_startRemoteIsolate, initPort.sendPort, debugName: name);
    } on Object {
      initPort.close();
      rethrow;
    }

    // Waiting for isolate's responding
    final (receivePort, sendPort) = await connection.future;
    return Worker._(receivePort, sendPort);
  }

  Worker._(this._responses, this._commands) {
    _responses.listen((dynamic message) {
      final (id, response) = message as (int, dynamic);
      final completer = _activeRequests.remove(id)!;

      if (response is RemoteError) {
        completer.completeError(response);
      } else {
        completer.complete(response);
      }

      if (_closed && _activeRequests.isEmpty) _responses.close();
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (id, data, handler) = message as (int, dynamic, Function);
      try {
        var result = handler(data);
        if (result is Future) {
            result = await result;
        }
        sendPort.send((id, result));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
    }
  }
}

