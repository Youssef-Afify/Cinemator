import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/auth/provider/auth_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/auth/views/auth_view.dart';

// Clears the signed-in user's info, resets the auth flow back to login,
// and replaces the whole navigation stack with AuthView so the user can't
// navigate back into a logged-out screen afterward.
void performLogout(BuildContext context) {
  context.read<UserProvider>().changeInfo(
    newUsername: 'N/A',
    newEmail: 'N/A',
  );
  context.read<AuthProvider>().changeIndex(AuthEnum.login);

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const AuthView()),
    (route) => false,
  );
}