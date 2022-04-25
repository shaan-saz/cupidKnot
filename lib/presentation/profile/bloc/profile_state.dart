part of 'profile_bloc.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();
  @override
  List<Object?> get props => [];
}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoading extends MyProfileState {}

class MyProfileLoaded extends MyProfileState {
  final Profile? userProfileModel;

  const MyProfileLoaded({this.userProfileModel});
  @override
  List<Object?> get props => [userProfileModel];
}

class MyProfileFailure extends MyProfileState {
  final String msg;

  const MyProfileFailure({required this.msg});
  @override
  List<Object?> get props => [msg];
}

class MyProfileEditing extends MyProfileState {
  final Profile? userProfileModel;

  const MyProfileEditing({this.userProfileModel});
  @override
  List<Object?> get props => [userProfileModel];
}
