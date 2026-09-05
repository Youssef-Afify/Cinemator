import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task/core/utils/pref_helper.dart';

class UserProvider extends ChangeNotifier {
  String username;
  String email;
  bool isAdmin;

  UserProvider({
    this.username = 'N/A',
    this.email = 'N/A',
    this.isAdmin = false,
  });

  void changeInfo({String? newUsername, String? newEmail}) async {
    username = newUsername ?? username;
    email = newEmail ?? email;
    await PrefHelper.saveSession(username, email);
    notifyListeners();
  }

  String profileIcon() {
    List<String> sections = username.split(' ');
    if (sections.length > 1) {
      return sections[0][0] + sections[1][0];
    }
    return sections[0][0];
  }

  /// Reads the `isAdmin` field from `users/{uid}` in Firestore.
  Future<void> loadAdminStatus(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        isAdmin = (doc.data()?['isAdmin'] as bool?) ?? false;
      } else {
        isAdmin = false;
      }
    } catch (_) {
      isAdmin = false;
    }
    notifyListeners();
  }

  /// Ensures a `users/{uid}` document exists, seeded with `name`, `email`,
  /// and `isAdmin: false`. Safe to call on every sign-in (email/password
  /// signup, email/password login, or Google) — it reads first and only
  /// writes if the document is completely absent, so it can never
  /// overwrite (and silently reset) an existing user's `isAdmin` value.
  /// That matters especially for Google sign-in: unlike email/password
  /// signup, Google doesn't have a separate "account creation" step to
  /// hook into, and a returning admin logging in via Google must not have
  /// their admin status quietly reset back to false.
  Future<void> ensureUserDocument({
    required String uid,
    required String name,
    required String email,
  }) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    try {
      final snapshot = await doc.get();
      if (snapshot.exists) return;
      await doc.set({'name': name, 'email': email, 'isAdmin': false});
    } catch (_) {
      // If this fails (e.g. offline), loadAdminStatus already treats a
      // missing doc as isAdmin: false — nothing else depends on this
      // succeeding immediately.
    }
  }

  // Unconditionally resets everything to defaults — used on logout.
  // Kept separate from changeInfo (which uses `newX ?? x` and so can
  // never null out / reset a field once set) so there's one atomic place
  // that clears the whole signed-in state, rather than relying on
  // multiple methods being called in the right order.
  void reset() {
    username = 'N/A';
    email = 'N/A';
    isAdmin = false;
    notifyListeners();
  }
}