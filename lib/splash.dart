import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/features/auth/views/auth_view.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(route(AuthView()));
    });
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
            Text(
              'CINEMATOR',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Manrope',
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'YOUR GATEWAY TO CINEMA',
              style: TextStyle(
                color: AppColors.neutral,
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w100,
              ),
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
