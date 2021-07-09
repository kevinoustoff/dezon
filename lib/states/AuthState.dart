import 'package:flutter/material.dart';
import '../resources/user_api_provider.dart';

class AuthState extends ChangeNotifier {
  String _email;
  String _password;
  UserApiProvider provider = UserApiProvider();

  String get getEmail => _email;
  String get password => _password;
  set setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  set setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<List> signIn({
    @required String email,
    @required String password,
  }) async {
    var user;
    //String errorMessage;
    try {
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      provider.login(email: email, password: password).then((response) {
        user = response.email;
      });

      return [true, user];
    } catch (e) {
      //print("Exception lors du signIn(): $e");
    }
    return [false, user];
  }
}
