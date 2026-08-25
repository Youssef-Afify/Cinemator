import 'package:flutter/material.dart';

enum AuthEnum {
  signup,
  login,
}

class AuthenticationProvider extends ChangeNotifier {
  AuthEnum authIndex;

  AuthenticationProvider([this.authIndex = AuthEnum.login]);

  void changeIndex(AuthEnum index) {
    authIndex = index;
    notifyListeners();
  }
}