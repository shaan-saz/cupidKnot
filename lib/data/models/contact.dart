import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String? name;
  final String? email;
  final String? contact;
  final DocumentSnapshot? snapshot;
  final DocumentReference? reference;
  final String? documentID;

  Contact({
    this.name,
    this.email,
    this.contact,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory Contact.fromFirestore(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map;

    return Contact(
      name: map['name'] as String,
      email: map['email'] as String,
      contact: map['contact'] as String,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      email: map['email'] as String,
      contact: map['contact'] as String,
    );
  }

  Map<String, Object?> toMap() => {
        'name': name,
        'email': email,
        'contact': contact,
      };

  Contact copyWith({
    String? name,
    String? email,
    String? contact,
  }) {
    return Contact(
      name: name ?? this.name,
      email: email ?? this.email,
      contact: contact ?? this.contact,
    );
  }

  @override
  String toString() {
    return '${name.toString()}, ${email.toString()}, ${contact.toString()}, ';
  }

  @override
  bool operator ==(Object other) =>
      other is Contact && documentID == other.documentID;

  @override
  int get hashCode => documentID.hashCode;
}
