import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_button.dart';
import 'package:task/shared/custom_text.dart';

class ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final EdgeInsetsGeometry padding;

  const ErrorRetry({
    super.key,
    required this.message,
    required this.onRetry,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.secondary,
            size: 32,
          ),
          const Gap(10),
          CustomText(
            message,
            color: Colors.white,
            size: 14,
            weight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          CustomButton(text: 'Retry', onTap: onRetry, height: 42, width: 120),
        ],
      ),
    );
  }
}