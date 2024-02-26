import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dtos.dart';

part 'retrofit_entries.g.dart';

@RestApi()
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
