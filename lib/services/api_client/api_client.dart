import 'dart:async';
import 'dart:math';

import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/users/users.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'dtos/dtos.dart';
import 'retrofit/retrofit_entries.dart';

export 'dtos/dtos.dart';

base class BaseApiClient {
  late final RestClient _client;
  final _dio = Dio();
  final _errorSubject = PublishSubject<MyError>();

  BaseApiClient() {
    _dio.options.baseUrl = 'https://dummyjson.com';
    // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _dio.interceptors.add(PrettyDioLogger());
    _client = RestClient(_dio);
  }

  /// This is currently used to attach the Auth feature to catch broken auth session
  Stream<MyError> get errors => _errorSubject.stream;

  @protected
  FutureResult<T> sendRequest<T>(Future<T> Function(RestClient client) requestBody) async {
    try {
      return Result.value(await requestBody(_client));
    } catch (e) {
      return Result.error(parseError(e));
    }
  }

  @protected
  void reportError(MyError error) {
    _errorSubject.add(error);
  }

  @protected
  MyError parseError(dynamic e) {
    if (e is DioException) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      // We will try to parse is as the legal the error message from the server first
      final response = e.response;
      if (response != null) {
        MyError error;
        try {
          final ErrorDto(message: message, name: name) = ErrorDto.fromJson(response.data);
          switch (response.statusCode) {
            case 401:
              if (name == 'TokenExpiredError') {
                error = MyError(message, type: MyErrorType.tokenExpired);
              } else {
                error = MyError.unauthorized(message);
              }
            case 500:
              // Welcome to reality. Some 500 dummyjson.com errors are 401 in disguise
              if (message == 'invalid signature') {
                error = MyError.unauthorized(message);
              } else {
                error = MyError(message);
              }

            default:
              error = MyError(message);
          }
        } catch (respException) {
          error = MyError.from(respException);
        }
        return error;
      }

      // Other DioException cases
      final originalMessage = e.message;
      return originalMessage == null ? MyError.from(e) : MyError(originalMessage);
    }

    // Something happened in setting up or sending the request that triggered an Error
    // Should never happen because Dio throws only DioException objects bu just in case
    assert(false, "Unexpected error from Dio: $e");
    return MyError.from(e);
  }
}

///
/// API client for public (un-authorized) requests. Exposes only public [RestClient] endpoints
///
@LazySingleton()
final class ApiClient extends BaseApiClient {
  ///
  /// This is an extended version of the [RestClient.signIn] method.
  /// Among with classic authorization it requests user info as well. This is just to demonstrate how to
  /// handle typical API behavior when DTO consists of few independent parts (parts that belong to different domains)
  ///
  FutureResult<(SignInResponseDto, UserDto)> signIn(SignInRequestDto request) async {
    final signInResult = await sendRequest((client) => client.signIn(request));
    if (signInResult.isError) {
      return Result.error(signInResult.requiredError);
    }

    final token = signInResult.requiredValue.token;
    final userResult = await sendRequest((client) => client.getMyUserAuthorized(bearerToken: 'Bearer $token'));
    if (userResult.isValue) {
      return Result.value((signInResult.requiredValue, userResult.requiredValue));
    }
    return Result.error(userResult.requiredError);
  }

  @override
  FutureResult<T> sendRequest<T>(Future<T> Function(RestClient client) requestBody) async {
    final result = await super.sendRequest(requestBody);
    if (result.isError) {
      reportError(result.requiredError);
    }
    return result;
  }

  FutureResult<UserDto?> getRandomUser() => sendRequest(
        (client) => client.getUsers(limit: 10).then(
          (value) {
            final users = value.users;
            if (users.isEmpty) {
              return null;
            }
            return users[Random().nextInt(users.length)];
          },
        ),
      );

  FutureResult<PostsDto> getPostsForUser({required UserId userId}) =>
      sendRequest((client) => client.getPostsForUser(userId: userId.value));
}

typedef AuthorizedApiClientCredentials = ({
  String token,
  int userId, // Not required for the API, but just as a demonstration of external data passed to the client
});

///
/// API client for authorized requests. It was easier to create a separate class and assign authorization interceptor
/// for all [RestClient] endpoints that require authorization header.
///
@LazySingleton()
final class AuthorizedApiClient extends BaseApiClient {
  AuthorizedApiClientCredentials? _credentials;

  final _refreshedCredentialsSubject = PublishSubject<AuthorizedApiClientCredentials>();

  AuthorizedApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_credentials != null) {
            options.headers['Authorization'] = 'Bearer ${_credentials?.token}';
          }
          handler.next(options);
        },
      ),
    );
  }

  /// This is currently used to attach the Auth feature to save broken auth session
  Stream<AuthorizedApiClientCredentials> get refreshedCredentials => _refreshedCredentialsSubject.stream;

  void setCredentials(AuthorizedApiClientCredentials? credentials) {
    _credentials = credentials;
  }

  FutureResult<UserDto> _refreshToken() async {
    // ... refresh the token and then deliver the result to the caller
    // ... setCredentials(...)
    // ... _tokenRefreshSubject.add(token)
    return Result.error(MyError('Token expired and there is no refreshing procedure implemented yet. Sign in again'));
  }

  @override
  FutureResult<T> sendRequest<T>(Future<T> Function(RestClient client) requestBody) async {
    var result = await super.sendRequest(requestBody);

    // ... Here is the place to handle the token expiration. We will try to refresh the token and repeat the request
    if (result.isError) {
      if (result.requiredError.type == MyErrorType.tokenExpired) {
        // refresh the token
        final tokenRefreshingResult = await super.sendRequest((client) => _refreshToken());
        if (tokenRefreshingResult.isError) {
          return tokenRefreshingResult.mapError();
        }

        // Retry the original request
        result = await super.sendRequest(requestBody);
      }
    }

    if (result.isError) {
      reportError(result.requiredError);
    }
    return result;
  }

  FutureResult<UserDto> getMyUser() async {
    return sendRequest((client) {
      return client.getMyUser(delayMilliseconds: 1000); // some delay to simulate the real network
    });
  }
}
