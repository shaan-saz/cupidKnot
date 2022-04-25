import 'package:bloc/bloc.dart';
import 'package:cupid_test/data/models/contact.dart';
import 'package:cupid_test/data/repositories/contact_repo.dart';
import 'package:equatable/equatable.dart';

part 'add_contact_state.dart';

class AddContactCubit extends Cubit<AddContactState> {
  AddContactCubit({ContactRepository? contactRepository})
      : _contactRepository = contactRepository,
        super(AddContactInitial());

  final ContactRepository? _contactRepository;

  Future<void> saveContact({required Contact contact, String? email}) async {
    emit(AddContactLoading());
    await _contactRepository!.saveContact(contact: contact, email: email);
    emit(AddContactSuccess());
  }
}
