import 'package:cupid_test/data/models/user.dart';
import 'package:cupid_test/data/providers/cloud_firestore.dart';
import 'package:cupid_test/data/providers/cupidknot_api.dart';
import 'package:cupid_test/data/providers/shared_prefs.dart';

class UserRepository {
  UserRepository(
      {CloudFirestoreClient? cloudFirestoreClient,
      SharedPrefsClient? sharedPrefsClient,
      CupidKnotAPI? cupidKnotAPI})
      : _cloudFirestoreClient = cloudFirestoreClient ?? CloudFirestoreClient(),
        _sharedPrefsClient = sharedPrefsClient ?? SharedPrefsClient(),
        _cupidKnotAPI = cupidKnotAPI ?? CupidKnotAPI();

  final CloudFirestoreClient _cloudFirestoreClient;
  final SharedPrefsClient _sharedPrefsClient;
  final CupidKnotAPI _cupidKnotAPI;

  Future<Profile> getUser() async {
    final email = await _sharedPrefsClient.getEmail();
    final user = await _cloudFirestoreClient.fetchProfile(email: email);
    return user;
  }

  Future<void> updateProfile({required Profile profile}) async {
    await _cloudFirestoreClient.updateProfile(profile: profile);
    await _cupidKnotAPI.editProfile(profile: profile);
  }
}
