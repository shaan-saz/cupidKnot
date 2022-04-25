import 'package:cupid_test/app.dart';
import 'package:cupid_test/bootstrap.dart';
import 'package:cupid_test/data/repositories/auth_repo.dart';
import 'package:cupid_test/data/repositories/contact_repo.dart';
import 'package:cupid_test/data/repositories/user_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenticationRepo = AuthenticationRepository();
  final userRepo = UserRepository();
  final contactRepo = ContactRepository();
  await bootstrap(
    () => MyApp(
      authenticationRepository: authenticationRepo,
      userRepository: userRepo,
      contactRepository: contactRepo,
    ),
  );
}
