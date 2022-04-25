import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cupid_test/data/models/contact.dart';
import 'package:cupid_test/data/repositories/contact_repo.dart';
import 'package:equatable/equatable.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit({ContactRepository? contactRepository})
      : _contactRepository = contactRepository ?? ContactRepository(),
        super(ContactsInitial());

  final ContactRepository _contactRepository;
  StreamSubscription? _contactsSubscription;

  Future<void> fetchContacts({String? email}) async {
    emit(ContactsLoading());
    final contactsStream = _contactRepository.fetchContacts(email: email);
    await _contactsSubscription?.cancel();
    _contactsSubscription = contactsStream.listen((contacts) {
      emit(ContactsLoaded(contacts: contacts));
    });
  }

  Future<void> deleteContact({String? documentId, String? email}) async {
    await _contactRepository.deleteContact(
      documentId: documentId,
      email: email,
    );
  }

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}
