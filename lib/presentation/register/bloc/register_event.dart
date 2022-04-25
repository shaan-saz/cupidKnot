part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

class RegisterBtnPressed extends RegisterEvent {
  final String? name, email, password, confirmPassword, phone, dob, gender;

  const RegisterBtnPressed({
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
    this.phone,
    this.dob,
    this.gender,
  });
  @override
  List<Object?> get props => [
        name,
        email,
        password,
        confirmPassword,
        phone,
        dob,
        gender,
      ];
}
