import 'dart:async';

import 'package:cupid_test/data/models/user.dart';
import 'package:cupid_test/data/providers/cloud_firestore.dart';
import 'package:cupid_test/data/providers/cupidknot_api.dart';
import 'package:cupid_test/data/providers/shared_prefs.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({
    CloudFirestoreClient? cloudFirestoreClient,
    CupidKnotAPI? cupidKnotAPI,
    SharedPrefsClient? sharedPrefsClient,
  })  : _cloudFirestoreClient = cloudFirestoreClient ?? CloudFirestoreClient(),
        _cupidKnotAPI = cupidKnotAPI ?? CupidKnotAPI(),
        _sharedPrefsClient = sharedPrefsClient ?? SharedPrefsClient();

  final _controller = StreamController<AuthenticationStatus>();
  final CloudFirestoreClient _cloudFirestoreClient;
  final CupidKnotAPI _cupidKnotAPI;
  final SharedPrefsClient _sharedPrefsClient;

  Stream<AuthenticationStatus> get status async* {
    final hasUser = await _sharedPrefsClient.hasUser();
    if (hasUser) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String? username,
    required String? password,
  }) async {
    final response =
        await _cupidKnotAPI.signIn(email: username, password: password);

    if (response?.data['success'] as bool) {
      await _sharedPrefsClient.persistUser(
        response?.data['data']['token'] as String,
        username!,
      );
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  Future<void> logOut() async {
    await _sharedPrefsClient.deleteUser();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> register(
      {String? name,
      String? password,
      String? email,
      String? confirmPassword,
      String? dob,
      String? gender,
      String? phoneNo}) async {
    final response = await _cupidKnotAPI.register(
      name: name,
      password: password,
      email: email,
      confirmPassword: confirmPassword,
      dob: dob,
      gender: gender,
      phoneNo: phoneNo,
    );
    if (response?.data['success'] as bool) {
      await _cloudFirestoreClient.saveProfile(
        profile: Profile(
          fullName: name,
          email: email,
          dob: dob,
          gender: gender,
          mobileNo: phoneNo,
        ),
      );

      await _sharedPrefsClient.persistUser(
        response?.data['data']['token'] as String,
        email!,
      );
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void dispose() => _controller.close();
}
