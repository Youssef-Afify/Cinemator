import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/core/utils/pref_helper.dart';
import 'package:task/features/auth/provider/auth_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/auth/views/auth_view.dart';

Future<void> performLogout(BuildContext context) async {
  context.read<UserProvider>().changeInfo(
    newUsername: 'N/A',
    newEmail: 'N/A',
  );
  context.read<AuthProvider>().changeIndex(AuthEnum.login);

  await PrefHelper.clearSession();

  if (!context.mounted) return;

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const AuthView()),
    (route) => false,
  );
}