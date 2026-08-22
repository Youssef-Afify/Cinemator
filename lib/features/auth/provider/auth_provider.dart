import 'package:flutter/material.dart';

enum AuthEnum {
  signup,
  login,
}

class AuthProvider extends ChangeNotifier {
  AuthEnum authIndex;

  AuthProvider([this.authIndex = AuthEnum.signup]);

  void changeIndex(AuthEnum index) {
    authIndex = index;
    notifyListeners();
  }
}