import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cupid_test/data/repositories/auth_repo.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({AuthenticationRepository? authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SignInInitial());

  final AuthenticationRepository? _authenticationRepository;

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInBtnPressed) {
      yield SignInLoading();
      try {
        await _authenticationRepository!.logIn(
          username: event.email,
          password: event.password,
        );
      } catch (e) {
        yield SignInFailure(msg: e.toString());
      }
    }
  }
}
