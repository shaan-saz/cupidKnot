import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String? fullName;
  final String? email;
  final String? mobileNo;
  final String? gender;
  final String? dob;
  final DocumentSnapshot? snapshot;
  final DocumentReference? reference;
  final String? documentID;

  const Profile({
    this.fullName,
    this.email,
    this.mobileNo,
    this.gender,
    this.dob,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory Profile.fromFirestore(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map;

    return Profile(
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      mobileNo: map['mobileNo'] as String,
      gender: map['gender'] as String,
      dob: map['dob'] as String,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      mobileNo: map['mobileNo'] as String,
      gender: map['gender'] as String,
      dob: map['dob'] as String,
    );
  }

  Map<String, Object?> toMap() => {
        'fullName': fullName,
        'email': email,
        'mobileNo': mobileNo,
        'gender': gender,
        'dob': dob,
      };

  Profile copyWith({
    String? fullName,
    String? email,
    String? mobileNo,
    String? gender,
    String? dob,
    DocumentSnapshot? snapshot,
    DocumentReference? reference,
    String? documentID,
  }) {
    return Profile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobileNo: mobileNo ?? this.mobileNo,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      snapshot: snapshot ?? this.snapshot,
      reference: reference ?? this.reference,
      documentID: documentID ?? this.documentID,
    );
  }

  static const empty = Profile(
    fullName: '',
    email: '',
    mobileNo: '',
    gender: '',
    dob: '',
  );

  @override
  String toString() {
    return '${fullName.toString()}, ${email.toString()}, ${mobileNo.toString()}, ${gender.toString()}, ${dob.toString()}, ';
  }

  @override
  List<Object?> get props {
    return [
      fullName,
      email,
      mobileNo,
      gender,
      dob,
      snapshot,
      reference,
      documentID,
    ];
  }
}
