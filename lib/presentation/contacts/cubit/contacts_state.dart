part of 'contacts_cubit.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<Contact> contacts;

  const ContactsLoaded({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}

class ContactsFailure extends ContactsState {}
