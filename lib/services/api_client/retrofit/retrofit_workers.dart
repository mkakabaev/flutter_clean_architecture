import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' as foundation;

import 'package:dio/dio.dart';
import 'package:mk_clean_architecture/core/core.dart';

//
// The collection of utils to make Dio->Retrofit serialize/deserialize DTOs efficiently
// The main idea is to use single worker for all the operations and avoid passing data between Dio and Retrofit
// isolates. Due current implementation Retrofit can work only with Map<String, dynamic> objects, so we mimic
// JSON serialization/deserialization by wrapping the data into a single-entry Map<String, dynamic> and processing
// it in Retrofit worker.
//

///
/// Transformer to pass background processing to Retrofit API calls. This way
/// we will try to avoid passing data between Dio & Retrofit isolates and do all
/// the work in the intercepted compute() function at Retrofit level.
/// We can't just pass the data as it is because Retrofit (currently) can work only with
/// Map<String, dynamic> objects, so we will create a fake JSON object and pass as is
///
class RetrofitWorkerBridgeTransformer extends SyncTransformer {
  RetrofitWorkerBridgeTransformer()
      : super(
          jsonDecodeCallback: _wrapJsonString2Map,
          jsonEncodeCallback: _unwrapJsonStringFromMap,
        );
}

Map<String, dynamic> _wrapJsonString2Map(String jsonText) => Map.unmodifiable({'j': jsonText}).cast<String, dynamic>();
String _unwrapJsonStringFromMap(Object jsonMap) => (jsonMap as Map).values.first;

/*
////
//// Here is an example of classic background isolate usage which is based on Worker (works
//// better than compute() )
////
class DioBackgroundTransformer extends SyncTransformer {
  late final Future<Worker> worker;
  Worker? _resolvedWorker;

  DioBackgroundTransformer() : super(jsonDecodeCallback: (_) => null) {
    worker = Worker.spawn(name: 'DioDecoderWorker');
    jsonDecodeCallback = (jsonText) async {
      final w = _resolvedWorker ??= await worker;
      return w.process(jsonDecode, jsonText);
    };
  }
}
*/

// Just a sample of how to split tasks between workers.
// We can use different workers for serialization and deserialization. More fine control can be
// achieved by analyzing the message type.

class _WorkerHolder {
  final Future<Worker> futureWorker;
  Worker? resolvedWorker;

  _WorkerHolder(String name) : futureWorker = Worker.spawn(name: name);
}

final _decoderWorker = _WorkerHolder('RetrofitDecoderWorker');
final _encoderWorker = _WorkerHolder('RetrofitEncoderWorker');

// This is to call in app's bootstrapping() to warm up the workers 
Future initWorkers() async {
  await _decoderWorker.futureWorker;
  await _encoderWorker.futureWorker;
}

Object _deserialization<R>(Object object) {
  final (callback, map) = object as (Function, Map);
  final jsonText = _unwrapJsonStringFromMap(map);
  final decodedJson = jsonDecode(jsonText);
  return callback(decodedJson);
}

Object _serialization(Object object) {
  final (callback, objectToSerialize) = object as (Function, Object);
  final json = callback(objectToSerialize);
  final encodedString = jsonEncode(json);
  return _wrapJsonString2Map(encodedString);
}

///
/// Overridden compute() function to be used by Retrofit API calls. As of now this is the only way
/// to set up external handler. Of course the should be exposed only to [RestClient] and Retrofit
///
/// This is used both for serialization and deserialization. To distinguish the behavior we just perform
/// a simple type check. If the message is a Map<String, dynamic> we assume it's a deserialization.
///
/// @param callback - the original serializeT/deserializeT used by Retrofit
//
Future<R> compute<M, R>(foundation.ComputeCallback<M, R> callback, M message) async {
  // Deserialize the message if it's a Map<String, dynamic>
  if (message is Map) {
    final stopwatch = MyStopwatch();
    final worker = _decoderWorker.resolvedWorker ??= await _decoderWorker.futureWorker;
    final result = await worker.process(_deserialization, (callback, message));
    stopwatch.stop("RETROFIT DESERIALIZE: ${result.runtimeType}, max active requests: ${worker.maxActiveRequests}");
    return result as R;
  }

  // Serialization otherwise
  {
    final stopwatch = MyStopwatch();
    final worker = _encoderWorker.resolvedWorker ??= await _encoderWorker.futureWorker;
    final result = await worker.process(_serialization, (callback, message));
    stopwatch.stop("RETROFIT SERIALIZE: ${result.runtimeType}, max active requests: ${worker.maxActiveRequests}");
    return result as R;
  }
}

// Simple helper to measure time. Move to core?
class MyStopwatch {
  final _sw = Stopwatch()..start();

  void stop(String label) {
    _sw.stop();
    developer.log("⏱️ $label: elapsed ${_sw.elapsedMicroseconds} µs");
  }
}
