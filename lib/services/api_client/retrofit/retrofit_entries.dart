import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:retrofit/retrofit.dart';

import '../dtos/dtos.dart';

part 'retrofit_entries.g.dart';

@RestApi(parser: Parser.FlutterCompute)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/auth/login')
  Future<SignInResponseDto> signIn(@Body() SignInRequestDto request);

  @GET('/users')
  Future<UsersDto> getUsers({
    @Query('limit') int? limit,
  });

  @GET('/user/me')
  Future<UserDto> getMyUser({@Query('delay') int? delayMilliseconds});

  ///
  /// A very special API call with direct authorization (no interceptors are used).
  /// See [ApiClient.signIn] for details.
  ///
  @GET('/user/me')
  Future<UserDto> getMyUserAuthorized({@Header('Authorization') required String bearerToken});

  @GET('/user/{id}/posts')
  Future<PostsDto> getPostsForUser({
    @Path('id') required int userId,
    @Query('limit') int? limit,
  });
}

// const compute = foundation.compute;
// 
// TODO: switch to isolate pools
//
Future<R>compute<M, R>(foundation.ComputeCallback<M, R> callback, M message, {String? debugLabel}) {

    final stopwatch2 = Stopwatch()..start();
    callback(message);
    stopwatch2.stop();
    // print
    print("Compute time without isolates: ${stopwatch2.elapsedMicroseconds } µs for $R parsing");

    final stopwatch = Stopwatch()..start();
    return foundation.compute(callback, message, debugLabel: debugLabel).then((value) {
        stopwatch.stop();
        print("Compute time: ${stopwatch.elapsedMicroseconds} µs for $R parsing");
        return value;
    });
}
