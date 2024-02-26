import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_clean_architecture/features/auth/auth.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/get_my_user.dart';
import '../../../domain/use_cases/reload_my_user.dart';

class UserProfilePageBlocState extends Equatable {
  final ValueState<User> user;
  const UserProfilePageBlocState({
    required this.user,
  });

  UserProfilePageBlocState copyWith({
    ValueState<User>? user,
  }) {
    return UserProfilePageBlocState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [user];
}

class UserProfilePageBloc extends PageBloc<UserProfilePageBlocState> {
  factory UserProfilePageBloc(PageController1 pageController) {
    return UserProfilePageBloc._(
      UserProfilePageBlocState(user: ValueState.empty()),
      pageController,
    );
  }

  UserProfilePageBloc._(super.initialState, super.pageController) {
    final myUserStream = getIt<GetMyUserUseCase>()();

    // Initiate data refreshing on page opening - if we have no data or broken data
    final userState = myUserStream.value;
    if (userState.isEmpty || userState.error != null) {
      Future(() => reloadUser()); // We need to wait for the page to be fully opened (initState is called)
    }

    // Listen to the user data stream
    disposeBag.subscriptions <<
        myUserStream.listen((value) {
          // In case we receive an error AFTER successful value fetching then we still will show
          // existing data but also will show an error popup.
          if (value case ValueStateLoadFailed(error: final error, value: final user) when user != null) {
            pageController.showError(error);
          }

          emit(state.copyWith(user: value));
        });
  }

  Future<void> signOut() async {
    await getIt<SignOutUseCase>()();
  }

  Future<void> reloadUser() async {
    pageController.hideErrors();
    await getIt<ReloadMyUserUseCase>()();
  }
}
