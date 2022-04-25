part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String? msg;

  const RegisterSuccess({this.msg});
  @override
  List<Object?> get props => [msg];
}

class RegisterFailure extends RegisterState {
  final String? msg;

  const RegisterFailure({this.msg});
  @override
  List<Object?> get props => [msg];
}
