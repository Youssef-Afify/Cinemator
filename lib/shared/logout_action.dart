import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:task/core/utils/pref_helper.dart';
import 'package:task/features/auth/provider/authentication_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/auth/views/auth_view.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
import 'package:task/shared/material_page_route.dart';

Future<void> performLogout(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn google = GoogleSignIn.instance;

  // Clear all local app state up front, before signing out or navigating,
  // while context is still guaranteed valid. Doing this after
  // pushAndRemoveUntil (as before) risks reading a provider through a
  // context whose route — and therefore provider scope — may already be
  // gone, since pushAndRemoveUntil just removed every prior route.
  if (context.mounted) {
    context.read<FavoritesProvider>().clearFavorites();
    context.read<UserProvider>().reset();
  }

  await PrefHelper.clearSession();
  await auth.signOut();
  await google.signOut();

  if (!context.mounted) return;
  context.read<AuthenticationProvider>().changeIndex(AuthEnum.login);
  Navigator.of(
    context,
  ).pushAndRemoveUntil(route(const AuthView()), (route) => false);
}