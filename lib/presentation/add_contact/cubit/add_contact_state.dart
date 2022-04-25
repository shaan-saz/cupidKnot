part of 'add_contact_cubit.dart';

abstract class AddContactState extends Equatable {
  const AddContactState();

  @override
  List<Object> get props => [];
}

class AddContactInitial extends AddContactState {}

class AddContactLoading extends AddContactState {}

class AddContactSuccess extends AddContactState {}

class AddContactFailure extends AddContactState {}
