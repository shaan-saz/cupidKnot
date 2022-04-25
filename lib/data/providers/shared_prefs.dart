import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsClient {
  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.get('token') as String?;
    return token;
  }

  Future<String?> getEmail() async {
    final pref = await SharedPreferences.getInstance();
    final email = pref.get('email') as String?;
    return email;
  }

  Future<bool> hasUser() async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    final _email = prefs.getString('email');
    return _token != null && _email != null;
  }

  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
  }

  Future<void> persistUser(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email);
  }
}
