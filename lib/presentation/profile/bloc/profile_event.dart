part of 'profile_bloc.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();
  @override
  List<Object?> get props => [];
}

class MyProfileFetch extends MyProfileEvent {}

class MyProfileEdit extends MyProfileEvent {
  final Profile? userProfileModel;

  const MyProfileEdit({this.userProfileModel});
  @override
  List<Object?> get props => [userProfileModel];
}

class MyProfileSave extends MyProfileEvent {
  final Profile? userProfileModel;

  const MyProfileSave({this.userProfileModel});
  @override
  List<Object?> get props => [userProfileModel];
}
