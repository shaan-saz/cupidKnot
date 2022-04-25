import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cupid_test/data/models/user.dart';
import 'package:cupid_test/data/repositories/auth_repo.dart';
import 'package:cupid_test/data/repositories/user_repo.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    AuthenticationRepository? authenticationRepository,
    UserRepository? userRepository,
  })  : _authenticationRepository =
            authenticationRepository ?? AuthenticationRepository(),
        _userRepository = userRepository ?? UserRepository(),
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  StreamSubscription<AuthenticationStatus>? _authenticationStatusSubscription;

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();

    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _userRepository.getUser();
        return emit(
          user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  Future<void> _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.logOut();
  }
}
