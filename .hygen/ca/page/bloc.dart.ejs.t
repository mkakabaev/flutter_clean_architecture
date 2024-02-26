---
to: <%= page_dir %>/bloc.dart
---
import 'package:equatable/equatable.dart';
import 'package:mk_clean_architecture/core/core.dart';

class <%= page_bloc_state_type %> extends Equatable {
  const <%= page_bloc_state_type %>();

  @override
  List<Object> get props => [];
}

class <%= page_bloc_type %> extends PageBloc< <%= page_bloc_state_type %>> {
  factory <%= page_bloc_type %>(PageController1 pageController) {
    const initialState = <%= page_bloc_state_type %>();
    return <%= page_bloc_type %>._(initialState, pageController);
  }

  <%= page_bloc_type %>._(super.initialState, super.pageController);
}


