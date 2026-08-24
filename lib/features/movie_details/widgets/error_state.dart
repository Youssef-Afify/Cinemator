import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_button.dart';
import 'package:task/shared/custom_text.dart';

class ErrorState extends StatelessWidget {
  final VoidCallback onBack;

  const ErrorState({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.secondary, size: 40),
          const Gap(12),
          const CustomText(
            'Could not load movie details',
            color: Colors.white,
            weight: FontWeight.w600,
          ),
          const Gap(20),
          CustomButton(text: 'Go Back', onTap: onBack, height: 42, width: 130),
        ],
      ),
    );
  }
}