import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), _initApp);
    });
  }

  Future<void> _initApp() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (!mounted) {
      return;
    }
    if (user != null) {
      context.read<UserProvider>().changeInfo(
        newUsername: user.displayName,
        newEmail: user.email,
      );
      // Load admin status from Firestore
      await context.read<UserProvider>().loadAdminStatus(user.uid);
      // Load persisted favorites from Firestore
      if (mounted) {
        await context.read<FavoritesProvider>().loadFavorites(user.uid);
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(route(const Root()));
      }
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
