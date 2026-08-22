import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String username;
  String email;

  UserProvider({this.username = 'N/A', this.email = 'N/A'});

  void changeInfo({
    String? newUsername,
    String? newEmail,
  }) async {
    username = newUsername ?? username;
    email = newEmail ?? email;
    notifyListeners();
  }
}
