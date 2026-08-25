import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:task/core/utils/pref_helper.dart';
import 'package:task/features/auth/provider/authentication_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/auth/views/auth_view.dart';
import 'package:task/shared/material_page_route.dart';

Future<void> performLogout(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn google = GoogleSignIn.instance;

  await PrefHelper.clearSession();
  await auth.signOut();
  await google.signOut();

  if (!context.mounted) return;
  context.read<AuthenticationProvider>().changeIndex(AuthEnum.login);
  Navigator.of(
    context,
  ).pushAndRemoveUntil(route(const AuthView()), (route) => false);
  context.read<UserProvider>().changeInfo(newUsername: 'N/A', newEmail: 'N/A');
}
