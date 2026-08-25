import 'package:flutter/material.dart';
import 'package:task/core/utils/pref_helper.dart';

class UserProvider extends ChangeNotifier {
  String username;
  String email;

  UserProvider({this.username = 'N/A', this.email = 'N/A'});

  void changeInfo({String? newUsername, String? newEmail}) async {
    username = newUsername ?? username;
    email = newEmail ?? email;
    await PrefHelper.saveSession(username, email);
    notifyListeners();
  }
}
