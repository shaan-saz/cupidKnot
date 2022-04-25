import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupid_test/data/models/contact.dart';
import 'package:cupid_test/data/models/user.dart';

class CloudFirestoreClient {
  final FirebaseFirestore _firebaseFirestore;

  CloudFirestoreClient({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> saveProfile({required Profile profile}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(profile.email)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<void> updateProfile({required Profile profile}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(profile.email)
        .set(profile.toMap());
  }

  Future<Profile> fetchProfile({String? email}) async {
    final response =
        await _firebaseFirestore.collection('users').doc(email).get();
    return Profile.fromFirestore(response);
  }

  Stream<List<Contact>> fetchContacts({String? email}) {
    final response = _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('contacts')
        .snapshots()
        .map(
          (event) => event.docs.map(Contact.fromFirestore).toList(),
        );

    return response;
  }

  Future<void> saveContact({required Contact contact, String? email}) async {
    print(contact.toMap());
    await _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('contacts')
        .add(contact.toMap());
  }

  Future<void> deleteContact({String? documentId, String? email}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('contacts')
        .doc(documentId)
        .delete();
  }
}
