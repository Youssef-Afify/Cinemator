import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/core/utils/pref_helper.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/features/auth/views/auth_view.dart';
import 'package:task/root.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      PrefHelper.getSession(),
    ]);

    if (!mounted) return;

    final session = results[1] as SessionData?;

    if (session != null) {
      context.read<UserProvider>().changeInfo(
        newUsername: session.name,
        newEmail: session.email,
      );
      Navigator.of(context).pushReplacement(route(const Root()));
    } else {
      Navigator.of(context).pushReplacement(route(const AuthView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.bg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie, color: AppColors.primary, size: 100),
            CustomText(
              AppInfo.name,
              color: AppColors.primary,
              size: 48,
              weight: FontWeight.w900,
              family: 'Manrope',
            ),
            CustomText(
              'YOUR GATEWAY TO CINEMA',
              color: AppColors.neutral,
              size: 18,
              weight: FontWeight.w100,
              family: 'Inter',
            ),
            Gap(20),
            LoadingAnimationWidget.progressiveDots(
              color: AppColors.primary,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}