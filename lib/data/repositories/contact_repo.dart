import 'package:cupid_test/data/models/contact.dart';
import 'package:cupid_test/data/providers/cloud_firestore.dart';

class ContactRepository {
  ContactRepository({CloudFirestoreClient? cloudFirestoreClient})
      : _cloudFirestoreClient = cloudFirestoreClient ?? CloudFirestoreClient();

  final CloudFirestoreClient _cloudFirestoreClient;

  Stream<List<Contact>> fetchContacts({String? email}) =>
      _cloudFirestoreClient.fetchContacts(email: email);

  Future<void> saveContact({required Contact contact, String? email}) async =>
      _cloudFirestoreClient.saveContact(contact: contact, email: email);

  Future<void> deleteContact({String? documentId, String? email}) async =>
      _cloudFirestoreClient.deleteContact(
        documentId: documentId,
        email: email,
      );
}
