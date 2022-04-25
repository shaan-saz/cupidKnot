import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cupid_test/data/repositories/auth_repo.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({AuthenticationRepository? authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(RegisterInitial());

  final AuthenticationRepository? _authenticationRepository;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    final currentState = state;
    if (event is RegisterBtnPressed) {
      yield RegisterLoading();

      try {
        await _authenticationRepository!.register(
          name: event.name,
          email: event.email,
          password: event.password,
          phoneNo: event.phone,
          confirmPassword: event.confirmPassword,
          gender: event.gender!.toUpperCase(),
          dob: event.dob,
        );
      } catch (e) {
        yield RegisterFailure(msg: e.toString());
      }
    }
    if (currentState is RegisterSuccess) {
      yield RegisterInitial();
    }
  }
}
