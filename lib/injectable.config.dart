// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:mk_clean_architecture/features/app/data/repositories/app_bootstrap_repository+impl.dart'
    as _i25;
import 'package:mk_clean_architecture/features/app/domain/repositories/app_bootstrap_repository.dart'
    as _i24;
import 'package:mk_clean_architecture/features/app/domain/use_cases/get_app_bootstrap_state.dart'
    as _i27;
import 'package:mk_clean_architecture/features/auth/auth.dart' as _i26;
import 'package:mk_clean_architecture/features/auth/data/repositories/auth_repository+impl.dart'
    as _i14;
import 'package:mk_clean_architecture/features/auth/domain/repositories/auth_repository.dart'
    as _i13;
import 'package:mk_clean_architecture/features/auth/domain/use_cases/get_auth_session.dart'
    as _i15;
import 'package:mk_clean_architecture/features/auth/domain/use_cases/get_credentials_hint.dart'
    as _i16;
import 'package:mk_clean_architecture/features/auth/domain/use_cases/sign_in_use_case.dart'
    as _i21;
import 'package:mk_clean_architecture/features/auth/domain/use_cases/sign_out_use_case.dart'
    as _i22;
import 'package:mk_clean_architecture/features/auth/domain/use_cases/validate_password.dart'
    as _i11;
import 'package:mk_clean_architecture/features/auth/domain/use_cases/validate_username.dart'
    as _i12;
import 'package:mk_clean_architecture/features/posts/data/repositories/posts_repository+impl.dart'
    as _i6;
import 'package:mk_clean_architecture/features/posts/domain/repositories/posts_repository.dart'
    as _i5;
import 'package:mk_clean_architecture/features/posts/domain/use_cases/get_my_posts.dart'
    as _i17;
import 'package:mk_clean_architecture/features/posts/domain/use_cases/get_posts_for_user.dart'
    as _i19;
import 'package:mk_clean_architecture/features/posts/domain/use_cases/reload_my_posts.dart'
    as _i7;
import 'package:mk_clean_architecture/features/users/data/repositories/users_repository+impl.dart'
    as _i10;
import 'package:mk_clean_architecture/features/users/domain/repositories/users_repository.dart'
    as _i9;
import 'package:mk_clean_architecture/features/users/domain/use_cases/get_my_user.dart'
    as _i18;
import 'package:mk_clean_architecture/features/users/domain/use_cases/reload_my_user.dart'
    as _i20;
import 'package:mk_clean_architecture/features/users/domain/use_cases/update_my_user.dart'
    as _i23;
import 'package:mk_clean_architecture/router.dart' as _i4;
import 'package:mk_clean_architecture/services/api_client/api_client.dart'
    as _i3;
import 'package:mk_clean_architecture/services/secure_storage/secure_storage.dart'
    as _i8;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.ApiClient>(() => _i3.ApiClient());
    gh.lazySingleton<_i3.AuthorizedApiClient>(() => _i3.AuthorizedApiClient());
    gh.lazySingleton<_i4.BadRoutePageRoute>(() => _i4.BadRoutePageRoute());
    gh.lazySingleton<_i4.HomeRoute>(() => _i4.HomeRoute());
    gh.lazySingleton<_i4.LaunchRoute>(() => _i4.LaunchRoute());
    gh.lazySingleton<_i5.PostsRepository>(
        () => _i6.PostsRepositoryImpl(gh<_i3.ApiClient>()));
    gh.lazySingleton<_i4.PostsRoute>(() => _i4.PostsRoute());
    gh.factory<_i7.ReloadMyPostsUseCase>(
        () => _i7.ReloadMyPostsUseCase(gh<_i5.PostsRepository>()));
    gh.lazySingleton<_i8.SecureStorage>(() => _i8.SecureStorage());
    gh.lazySingleton<_i4.SignInRoute>(() => _i4.SignInRoute());
    gh.lazySingleton<_i4.SignUpRoute>(() => _i4.SignUpRoute());
    gh.lazySingleton<_i4.UserProfileRoute>(() => _i4.UserProfileRoute());
    gh.lazySingleton<_i9.UsersRepository>(
        () => _i10.UsersRepositoryImpl(gh<_i3.AuthorizedApiClient>()));
    gh.factory<_i11.ValidatePasswordUseCase>(
        () => _i11.ValidatePasswordUseCase());
    gh.factory<_i12.ValidateUsernameUseCase>(
        () => _i12.ValidateUsernameUseCase());
    gh.lazySingleton<_i13.AuthRepository>(() => _i14.AuthRepositoryImpl(
          gh<_i3.ApiClient>(),
          gh<_i3.AuthorizedApiClient>(),
          gh<_i8.SecureStorage>(),
        ));
    gh.factory<_i15.GetAuthSessionUseCase>(
        () => _i15.GetAuthSessionUseCase(gh<_i13.AuthRepository>()));
    gh.factory<_i16.GetCredentialsHintUseCase>(
        () => _i16.GetCredentialsHintUseCase(gh<_i13.AuthRepository>()));
    gh.factory<_i17.GetMyPostsUseCase>(
        () => _i17.GetMyPostsUseCase(gh<_i5.PostsRepository>()));
    gh.factory<_i18.GetMyUserUseCase>(
        () => _i18.GetMyUserUseCase(gh<_i9.UsersRepository>()));
    gh.factory<_i19.GetPostsForUserUseCase>(
        () => _i19.GetPostsForUserUseCase(gh<_i5.PostsRepository>()));
    gh.factory<_i20.ReloadMyUserUseCase>(
        () => _i20.ReloadMyUserUseCase(gh<_i9.UsersRepository>()));
    gh.factory<_i21.SignInUseCase>(
        () => _i21.SignInUseCase(gh<_i13.AuthRepository>()));
    gh.factory<_i22.SignOutUseCase>(
        () => _i22.SignOutUseCase(gh<_i13.AuthRepository>()));
    gh.factory<_i23.UpdateMyUserUseCase>(
        () => _i23.UpdateMyUserUseCase(gh<_i9.UsersRepository>()));
    gh.lazySingleton<_i24.AppBootstrapRepository>(() =>
        _i25.AppBootstrapRepositoryImpl(gh<_i26.GetAuthSessionUseCase>()));
    gh.factory<_i27.GetAppBootstrapStateUseCase>(() =>
        _i27.GetAppBootstrapStateUseCase(gh<_i24.AppBootstrapRepository>()));
    return this;
  }
}
