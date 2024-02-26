import 'package:equatable/equatable.dart';

sealed class AppBootstrapState extends Equatable {
  const AppBootstrapState();

  factory AppBootstrapState.initial() => const AppBootstrapStateInitial();
}

class AppBootstrapStateInitial extends AppBootstrapState {
  const AppBootstrapStateInitial();

  @override
  List<Object?> get props => [];
}

class AppBootstrapStateReady extends AppBootstrapState {
  // final String initialRoute;
  final bool authenticated;

  const AppBootstrapStateReady(
      {
      // required this.initialRoute,
      required this.authenticated});

  @override
  List<Object?> get props => [authenticated];
}
