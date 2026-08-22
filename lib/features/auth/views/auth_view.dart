import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/auth/provider/auth_provider.dart';
import 'package:task/features/auth/widgets/login_view.dart';
import 'package:task/features/auth/widgets/signup_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  static const Map<AuthEnum, Widget> authMap = {
    AuthEnum.signup: SignupView(),
    AuthEnum.login: LoginView(),
  };
  @override
  Widget build(BuildContext context) {
    AuthEnum key = context.watch<AuthProvider>().authIndex;
    return authMap[key]!;
  }
}
