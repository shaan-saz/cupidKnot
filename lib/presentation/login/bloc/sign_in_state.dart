part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String? msg;

  const SignInSuccess({this.msg});
  @override
  List<Object?> get props => [msg];
}

class SignInFailure extends SignInState {
  final String? msg;

  const SignInFailure({this.msg});
  @override
  List<Object?> get props => [msg];
}
